//
//  AppService+StoreKit.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/01.
//

import Foundation
import SwiftyStoreKit
import CocoaLumberjackSwift

extension AppService {
    internal func purchaseProduct(identifier: String) {
        SwiftyStoreKit.purchaseProduct(identifier, quantity: 1, atomically: true, completion: { result in
            switch result {
            case .success(let purchase):
                DDLogInfo("Purchase Success: \(purchase.productId)")
            case .error(let error):
                switch error.code {
                case .unknown:
                    DDLogInfo("Unknown error. Please contact support")
                case .clientInvalid:
                    DDLogInfo("Not allowed to make the payment")
                case .paymentCancelled:
                    break
                case .paymentInvalid:
                    DDLogInfo("The purchase identifier was invalid")
                case .paymentNotAllowed:
                    DDLogInfo("The device is not allowed to make the payment")
                case .storeProductNotAvailable:
                    DDLogInfo("The product is not available in the current storefront")
                case .cloudServicePermissionDenied:
                    DDLogInfo("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed:
                    DDLogInfo("Could not connect to the network")
                case .cloudServiceRevoked:
                    DDLogInfo("User has revoked permission to use this cloud service")
                default:
                    DDLogInfo((error as NSError).localizedDescription)
                }
            case .deferred(let purchase):
                DDLogInfo("Purchase Deferred \(purchase.productId)")
            }
            
        })
    }
}
