//
//  StoreKitManager.swift
//  Salmonia3
//
//  Created by devonly on 2021/08/09.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import StoreKit

final class StoreKitManager {
    private init() {}
    
    static let shared: StoreKitManager = StoreKitManager()
    
    enum StoreItem: String, CaseIterable {
        case disableads     = "work.tkgstrator.disableads"
        case multiaccounts  = "work.tkgstrator.multiaccounts"
    }

    // MARK: プロダクトの購入
    /// プロダクトの購入
    func purchaseItemFromAppStore(productId: String) {
        let product: StoreItem = StoreKitManager.StoreItem(rawValue: productId)!

        SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                // 購入成功した場合もログに出力
                log.debug("Purchase Success: \(purchase.productId)")
                product.setEnabled(true)
            case .error(let error):
                // エラーが発生した場合はログに出力
                log.error("Purchase Failure: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: サーバからデータを取得
    /// サーバからデータを取得
    func retreiveProductInfo(productIds: [StoreItem], completion: @escaping (Set<SKProduct>) -> ()) {
        SwiftyStoreKit.retrieveProductsInfo(Set(productIds.map({ $0.rawValue }))) { result in
            for product in result.retrievedProducts {
                if let price = product.localizedPrice {
                    log.debug("Product: \(product.localizedDescription), Price: \(price)")
                }
            }
            if let invalidProductId = result.invalidProductIDs.first {
                log.error("Invalid Product: \(invalidProductId)")
            }
            completion(result.retrievedProducts)
        }
    }
    
    // MARK: 購入済みのアイテムを復元
    /// 購入済みのアイテムを復元
    func restorePurchases() {
        SwiftyStoreKit.restorePurchases(atomically: true) { result in
            for product in result.restoredPurchases {
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                
                // 購入したことをUserDefaultsに記録する
                switch StoreKitManager.StoreItem(rawValue: product.productId) {
                case .disableads:
                    product.setEnabled(true)
                    log.debug("Restore Success: \(result.restoredPurchases)")
                case .multiaccounts:
                    product.setEnabled(true)
                    log.debug("Restore Success: \(result.restoredPurchases)")
                default:
                    log.debug("Unknown Product: \(result.restoredPurchases)")
                }
            }
        }
    }
    
    // MARK: 購入済みのアイテムをロック
    /// 購入済みのアイテムをロック
    func lockPurchasedItes() {
        for item in StoreKitManager.StoreItem.allCases {
            item.setEnabled(false)
        }
    }
}

extension SKProduct {
    func setEnabled(_ newValue: Bool) {
        UserDefaults.standard.set(newValue, forKey: self.productIdentifier)
    }
    var isPurchased: Bool {
        UserDefaults.standard.bool(forKey: self.productIdentifier)
    }
}

private extension StoreKitManager.StoreItem {
    func setEnabled(_ newValue: Bool) {
        UserDefaults.standard.set(newValue, forKey: self.rawValue)
    }
    var isPurchased: Bool {
        UserDefaults.standard.bool(forKey: self.rawValue)
    }
}

private extension Purchase {
    func setEnabled(_ newValue: Bool) {
        UserDefaults.standard.set(newValue, forKey: self.productId)
    }
    var isPurchased: Bool {
        UserDefaults.standard.bool(forKey: self.productId)
    }
}
