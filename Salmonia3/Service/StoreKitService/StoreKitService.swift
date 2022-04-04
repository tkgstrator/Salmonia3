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

enum ProductIdentifier {
    enum Consumable: String, CaseIterable {
        case chip500 = "work.tkgstrator.salmonia3.chip500"
        case cnip980 = "work.tkgstrator.salmonia3.chip980"
    }
    
    enum NonConsumable: String, CaseIterable {
        case multiaccount = "work.tkgstrator.multiaccounts"
        case disableads = "work.tkgstrator.disableads"
    }
    
    enum AutoRenewable: String, CaseIterable {
        case apiupdate = "work.tkgstrator.upgradeapi"
    }
    
    enum Renewable: String, CaseIterable {
        case unknown
    }
}

final class StoreKitService: ObservableObject {
    @AppStorage("work.tkgstrator.forcerefresh") var forceRefresh: Bool = false
    @AppStorage(ProductIdentifier.NonConsumable.multiaccount.rawValue) var isEnabledMultiAccounts: Bool = false
    @AppStorage(ProductIdentifier.AutoRenewable.apiupdate.rawValue) var isEnabledAPIUpdate: Bool = false
    @AppStorage(ProductIdentifier.NonConsumable.disableads.rawValue) var isDisabledAds: Bool = true

    init() {
        
    }
    
    internal let validator = AppleReceiptValidator(service: .production, sharedSecret: "f9af1771ac2d44e6b595fd900c8b5826")

    internal func purchaseProduct(identifier: String) {
        SwiftyStoreKit.purchaseProduct(identifier, completion: { result in
            switch result {
            case .success(let purchase):
                DDLogInfo("Purchase success: \(purchase.productId)")
            case .deferred(let purchase):
                DDLogInfo("Purchase Deferred: \(purchase.productId)")
            case .error(let error):
                DDLogError("Purchase Error: \(error.localizedDescription)")
            }
        })
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
                        if let productId = ProductIdentifier.AutoRenewable(rawValue: productId.rawValue) {
                            UserDefaults.standard.setValue(true, forKey: productId.rawValue)
                        }
                    case .expired(let expiredDate, _):
                        if let productId = ProductIdentifier.AutoRenewable(rawValue: productId.rawValue) {
                            UserDefaults.standard.setValue(false, forKey: productId.rawValue)
                        }
                    case .notPurchased:
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
    
    /// 非消費型のレシート懸賞
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
