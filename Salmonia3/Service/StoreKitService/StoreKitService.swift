//
//  StoreKitService.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/29.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import CocoaLumberjackSwift
import StoreKit
import SwiftUI
import Combine

final class StoreKitService: ObservableObject {
    // 複数アカウント
    @AppStorage(ProductIdentifier.NonConsumable.multiaccount.rawValue) var isEnabledMultiAccounts: Bool = false
    // 自動アップデート機能
    @AppStorage(ProductIdentifier.AutoRenewable.apiupdate.rawValue) var isEnabledAPIUpdate: Bool = false
    // 広告非表示
    @AppStorage(ProductIdentifier.NonConsumable.disableads.rawValue) var isDisabledAds: Bool = true
    // 課金アイテム
    @Published var retrieveProducts: [SKProduct] = []

    init() {
        // レシートを検証してそれぞれの機能が有効かどうかをチェックする
        DDLogInfo("レシートの検証を行います")
        verifyAutoRenewableReceipt(forceRefresh: true)
        retrieveProductsInfo()
    }
    
    internal let validator = AppleReceiptValidator(service: .production, sharedSecret: "f9af1771ac2d44e6b595fd900c8b5826")

    internal func purchaseProduct(identifier: String) {
        SwiftyStoreKit.purchaseProduct(identifier, completion: { result in
            switch result {
            case .success(let purchase):
                DDLogInfo("Purchase success: \(purchase.productId)")
                UserDefaults.standard.set(true, forKey: purchase.productId)
            case .deferred(let purchase):
                DDLogInfo("Purchase Deferred: \(purchase.productId)")
            case .error(let error):
                DDLogError("Purchase Error: \(error.localizedDescription)")
            }
        })
    }

    // 全ての非消費型コンテンツの無効化
    internal func deactivateNonConsumableContents() {
        for productIdentifier in ProductIdentifier.NonConsumable.allCases {
            UserDefaults.standard.set(false, forKey: productIdentifier.rawValue)
        }
    }

    // 購入済みの項目の復元
    internal func restorePurchasedProducts() -> AnyPublisher<Bool, Never> {
        // 全ての非消費型コンテンツの無効化
        deactivateNonConsumableContents()
        return Future { promise in
            SwiftyStoreKit.restorePurchases(atomically: true, completion: { results in
                // 一度全ての非消費型コンテンツを無効化
                for product in results.restoredPurchases {
                    let productIdentifier: String = product.productId
                    // 非消費型であればすべて復元
                    if let product = ProductIdentifier.NonConsumable(rawValue: productIdentifier) {
                        // 復元成功
                        UserDefaults.standard.set(true, forKey: productIdentifier)
                        DDLogInfo(product)
                    }
                    promise(.success(true))
                }
            })
        }
        .eraseToAnyPublisher()
    }

    internal func retrieveProductsInfo() {
        let productIds: Set<String> = Set(ProductIdentifier.allCases)
        SwiftyStoreKit.retrieveProductsInfo(productIds, completion: ({ results in
            if let error = results.error {
                DDLogError(error.localizedDescription)
            }
            self.retrieveProducts = Array(results.retrievedProducts)
//            let invalidProducts: Set<String> = results.invalidProductIDs
        }))
    }

    /// 自動購読の期限チェック
    internal func verifyAutoRenewableReceipt(forceRefresh: Bool) {
        for productId in ProductIdentifier.AutoRenewable.allCases {
            SwiftyStoreKit.verifyReceipt(using: validator, forceRefresh: forceRefresh, completion: { result in
                switch result {
                case .success(let receiptData):
                    let purchaseResult = SwiftyStoreKit.verifySubscription(ofType: .autoRenewable, productId: productId.rawValue, inReceipt: receiptData)
                    switch purchaseResult {
                    case .purchased(let expiryDate, _):
                        // 有効期限が現在時刻よりも後なら機能を有効化、そうでないなら無効化
                        DDLogInfo("Valid \(expiryDate) -> \(productId)")
                        if let productId = ProductIdentifier.AutoRenewable(rawValue: productId.rawValue) {
                            UserDefaults.standard.setValue(true, forKey: productId.rawValue)
                        }
                    case .expired(let expiryDate, _):
                        DDLogInfo("Expired \(expiryDate) -> \(productId)")
                        if let productId = ProductIdentifier.AutoRenewable(rawValue: productId.rawValue) {
                            UserDefaults.standard.setValue(false, forKey: productId.rawValue)
                        }
                    case .notPurchased:
                        DDLogInfo("Not purchased -> \(productId)")
                        if let productId = ProductIdentifier.AutoRenewable(rawValue: productId.rawValue) {
                            UserDefaults.standard.setValue(false, forKey: productId.rawValue)
                        }
                    }
                case .error(let error):
                    DDLogError(error)
                }
            })
        }
    }
    
    /// 自動購読のレシート検証
    internal func verifyAutoRenewableProducts(forceRefresh: Bool) {
        SwiftyStoreKit.verifyReceipt(using: validator, forceRefresh: forceRefresh, completion: { result in
            switch result {
            case .success(let receiptData):
                for productId in ProductIdentifier.AutoRenewable.allCases {
                    let purchaseResult = SwiftyStoreKit.verifySubscription(ofType: .autoRenewable, productId: productId.rawValue, inReceipt: receiptData)
                    switch purchaseResult {
                    case .purchased(let expiredDate, _):
                        DDLogInfo("Expired date: \(expiredDate) -> \(productId.rawValue)")
                        if let productId = ProductIdentifier.AutoRenewable(rawValue: productId.rawValue) {
                            UserDefaults.standard.setValue(true, forKey: productId.rawValue)
                        }
                    case .expired(let expiredDate, _):
                        DDLogInfo("Expired date: \(expiredDate) -> \(productId.rawValue)")
                        if let productId = ProductIdentifier.AutoRenewable(rawValue: productId.rawValue) {
                            UserDefaults.standard.setValue(false, forKey: productId.rawValue)
                        }
                    case .notPurchased:
                        DDLogInfo("Expired date: Not purchased -> \(productId.rawValue)")
                        if let productId = ProductIdentifier.AutoRenewable(rawValue: productId.rawValue) {
                            UserDefaults.standard.setValue(false, forKey: productId.rawValue)
                        }
                    }
                }
            case .error(let error):
                DDLogError(error.localizedDescription)
            }
        })
    }
    
    /// 非消費型のレシート検証
    internal func verifyNonConsumableProducts(forceRefresh: Bool) {
        SwiftyStoreKit.verifyReceipt(using: validator, forceRefresh: forceRefresh, completion: { result in
            switch result {
            case .success(let receiptData):
                for productId in ProductIdentifier.NonConsumable.allCases {
                    let purchaseResult = SwiftyStoreKit.verifyPurchase(productId: productId.rawValue, inReceipt: receiptData)
                    switch purchaseResult {
                    case .purchased(let item):
                        if let productId = ProductIdentifier.NonConsumable(rawValue: item.productId) {
                            UserDefaults.standard.setValue(true, forKey: productId.rawValue)
                        }
                    case .notPurchased:
                        if let productId = ProductIdentifier.NonConsumable(rawValue: productId.rawValue) {
                            UserDefaults.standard.setValue(false, forKey: productId.rawValue)
                        }
                    }
                }
            case .error(let error):
                DDLogError(error.localizedDescription)
            }
        })
    }
}
