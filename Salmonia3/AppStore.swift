//
//  AppStore.swift
//  Salmonia3
//
//  Created by devonly on 2021/08/09.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftyStoreKit

final class StoreKitManager {
    private init() {}
    static let shared: StoreKitManager = StoreKitManager()
    
    enum StoreItem: String, CaseIterable {
        case disableads = "work.tkgstrator.disableads"
    }

    // MARK: プロダクトの購入
    /// プロダクトの購入
    private func purchaseItemFromAppStore(productId: String) {
        SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                // 購入成功した場合もログに出力
                log.debug("Purchase Success: \(purchase.productId)")
            case .error(let error):
                // エラーが発生した場合はログに出力
                log.error("Purchase Failure: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: サーバからデータを取得
    /// サーバからデータを取得
    private func retreiveProductInfo(productIds: [StoreItem]) {
        SwiftyStoreKit.retrieveProductsInfo(Set(productIds.map({ $0.rawValue }))) { result in
            if let product = result.retrievedProducts.first {
                if let price = product.localizedPrice {
                    log.debug("Product: \(product.localizedDescription), Price: \(price)")
                }
            }
            if let invalidProductId = result.invalidProductIDs.first {
                log.error("Invalid Product: \(invalidProductId)")
            }
        }
    }
    
    // MARK: 購入済みのアイテムを復元
    /// 購入済みのアイテムを復元
    private func restorePurchases() {
        
        SwiftyStoreKit.restorePurchases(atomically: true) { result in
            for product in result.restoredPurchases {
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                
                // 購入したことをUserDefaultsに記録する
                switch StoreItem(rawValue: product.productId) {
                case .disableads:
                    UserDefaults.standard.set(true, forKey: product.productId)
                    log.debug("Restore Success: \(result.restoredPurchases)")
                default:
                    log.debug("Unknown Product: \(result.restoredPurchases)")
                }
            }
        }
    }

}
