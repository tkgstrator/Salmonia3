//
//  SettingView+StoreKit.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/29.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftyStoreKit
import CocoaLumberjackSwift
import StoreKit

struct SettingView_StoreKit: View {
    @State private var isPresented: Bool = false
    @State private var skError: SKError?
    @State private var receiptError: ReceiptError?
    @State private var dateString: String = ""

    var body: some View {
        Form(content: {
            Section(content: {
                Button(action: {
                    purchaseAndVerify(productId: "work.tkgstrator.upgradeapi", forceRefresh: true)
                }, label: {
                    Text("Purchase And Verify Apple")
                })
                Button(action: {
                    purchaseAndVerify(productId: "work.tkgstrator.upgradeapi", forceRefresh: false)
                }, label: {
                    Text("Purchase And Verify Local")
                })
            }, header: {
                Text("Purchase")
            })
            Section(content: {
                Button(action: {
                    verifyReceiptData(productId: "work.tkgstrator.upgradeapi", forceRefresh: true)
                }, label: {
                    Text("Verify Receipt Data From Apple")
                })
                Button(action: {
                    verifyReceiptData(productId: "work.tkgstrator.upgradeapi", forceRefresh: false)
                }, label: {
                    Text("Verify Receipt Data From Local")
                })
            }, header: {
                Text("Verify")
            })
            Section(content: {
                Button(action: {
                    getReceiptFromApple()
                }, label: {
                    Text("Get Recipt From Apple")
                })
                Button(action: {
                    getReceiptFromApple()
                }, label: {
                    Text("Get Recipt From Local")
                })
            }, header: {
                Text("Get Receipt")
            })
        })
        .navigationTitle("StoreKit")
        .navigationBarTitleDisplayMode(.inline)
//        .alert(isPresented: $isPresented, error: skError, actions: { error in
//            Button("OK", action: {
//            })
//        }, message: { error in
//            Text(error.failureReason ?? "Unknown error.")
//        })
//        .alert(isPresented: $isPresented, error: receiptError, actions: { error in
//            Button("OK", action: {
//            })
//        }, message: { error in
//            Text(error.failureReason ?? "Unknown error.")
//        })
    }
    
    func getReceiptFromLocal() {
        DDLogInfo(SwiftyStoreKit.localReceiptData?.base64EncodedString(options: []))
    }
    
    func getReceiptFromApple() {
        SwiftyStoreKit.fetchReceipt(forceRefresh: true, completion: { result in
            switch result {
            case .success(let receiptData):
                DDLogInfo(receiptData.base64EncodedString(options: []))
            case .error(let error):
                self.receiptError = error
                self.isPresented.toggle()
                DDLogError(error)
            }
        })
    }
    
    func verifyReceiptData(productId: String, forceRefresh: Bool) {
        let validator = AppleReceiptValidator(service: .production, sharedSecret: "f9af1771ac2d44e6b595fd900c8b5826")
        SwiftyStoreKit.verifyReceipt(using: validator, forceRefresh: forceRefresh, completion: { result in
            switch result {
            case .success(let receiptData):
                let purchaseResult = SwiftyStoreKit.verifySubscription(ofType: .autoRenewable, productId: productId, inReceipt: receiptData)
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    DDLogInfo("Valid \(expiryDate)")
                case .expired(let expiryDate, let items):
                    DDLogInfo("Expired \(expiryDate)")
                case .notPurchased:
                    DDLogInfo("Not purchased")
                }
            case .error(let error):
                self.receiptError = error
                DDLogError(error)
            }
        })
    }
    
    func purchaseAndVerify(productId: String, forceRefresh: Bool) {
        SwiftyStoreKit.purchaseProduct(productId, atomically: true, completion: { result in
            switch result {
            case .success(let purchace):
                if purchace.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchace.transaction)
                }
                verifyReceiptData(productId: productId, forceRefresh: forceRefresh)
            case .deferred(let purchase):
                DDLogInfo(purchase)
            case .error(let error):
                self.skError = error
                DDLogError(error)
            }
        })
    }
}

struct SettingView_StoreKit_Previews: PreviewProvider {
    static var previews: some View {
        SettingView_StoreKit()
    }
}
