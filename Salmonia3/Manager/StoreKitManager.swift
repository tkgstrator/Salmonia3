//
//  StoreKitManager.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/08/09.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import StoreKit

extension SKProduct {
    var rawValue: StoreKitManager.StoreItem {
        StoreKitManager.StoreItem.allCases.filter({ $0.rawValue == self.productIdentifier }).first!
    }
}

final class StoreKitManager: ObservableObject {
    private init() {}
    static let shared: StoreKitManager = StoreKitManager()
    
    enum StoreItem: String, CaseIterable, Identifiable {
        var id: String { rawValue }
        case disableads     = "work.tkgstrator.disableads"
        case multiaccounts  = "work.tkgstrator.multiaccounts"
//        case lottery        = "work.tkgstrator.lottery"
        case upgradeapi     = "work.tkgstrator.upgradeapi"

        var imageName: String {
            switch self {
            case .disableads:
                return "eye.slash"
            case .multiaccounts:
                return "person.3"
//            case .lottery:
//                return "giftcard"
            case .upgradeapi:
                return "network"
            }
        }

        var isEnabled: Bool {
            get {
                UserDefaults.standard.bool(forKey: self.rawValue)
            }
        }
    }
    

    func setValue(product: StoreItem, _ newValue: Bool) {
        UserDefaults.standard.setValue(newValue, forKey: product.rawValue)
        objectWillChange.send()
    }

    /// プロダクトの購入
    func purchaseItemFromAppStore(product: StoreItem) {
        SwiftyStoreKit.purchaseProduct(product.rawValue, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                // 購入成功した場合もログに出力
                log.debug("Purchase Success: \(purchase.productId)")
                self.setValue(product: product, true)
            case .error(let error):
                // エラーが発生した場合はログに出力
                log.error("Purchase Failure: \(error.localizedDescription)")
            }
        }
    }
    
    /// サーバからデータを取得
    func retreiveProductInfo(productIds: [StoreItem], completion: @escaping (Set<SKProduct>) -> ()) {
        SwiftyStoreKit.retrieveProductsInfo(Set(productIds.map({ $0.rawValue }))) { result in
            if let invalidProductId = result.invalidProductIDs.first {
                log.error("Invalid Product: \(invalidProductId)")
            }
            completion(result.retrievedProducts)
        }
    }
    
    /// 購入済みのアイテムを復元
    func restorePurchases(completion: @escaping (Result<Bool, SKError>)->()) {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                completion(.failure(.noRestoredProduct))
            }
            
            for purchase in results.restoredPurchases {
                // 購入処理の最中なら続ける
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
               
                // 購入したアイテムを復元
                if let product = StoreItem(rawValue: purchase.productId) {
                    self.setValue(product: product, true)
                    log.debug("Restore Success: \(product.rawValue)")
                }
            }
            completion(.success(true))
        }
    }
    
    /// 購入済みのアイテムをロック
    func lockPurchasedItes() {
        for product in StoreKitManager.StoreItem.allCases {
            setValue(product: product, false)
        }
    }
}

//extension SKProduct {
//    func setEnabled(_ newValue: Bool) {
//        UserDefaults.standard.set(newValue, forKey: self.productIdentifier)
//    }
//    var isPurchased: Bool {
//        UserDefaults.standard.bool(forKey: self.productIdentifier)
//    }
//}
//
//private extension StoreKitManager.StoreItem {
//    func setValue(_ newValue: Bool) {
//        UserDefaults.standard.set(newValue, forKey: self.rawValue)
//    }
//    var isPurchased: Bool {
//        UserDefaults.standard.bool(forKey: self.rawValue)
//    }
//}

//private extension Purchase {
//    func setValue(_ newValue: Bool) {
//        UserDefaults.standard.set(newValue, forKey: self.productId)
//    }
//    var isPurchased: Bool {
//        UserDefaults.standard.bool(forKey: self.productId)
//    }
//}
