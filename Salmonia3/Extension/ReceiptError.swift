//
//  ReceiptError.swift
//  Salmonia3
//
//  Created by devonly on 2022/04/01.
//  
//

import Foundation
import StoreKit
import SwiftyStoreKit
import Combine

extension SwiftyStoreKit {
    class func valifySubscription() -> AnyPublisher<Bool, Error> {
        Future { promise in
            let validator = AppleReceiptValidator(service: .production, sharedSecret: "f9af1771ac2d44e6b595fd900c8b5826")
            verifyReceipt(using: validator, forceRefresh: true, completion: { result in
                switch result {
                case .success(let receipt):
                    let productId = "work.tkgstrator.apiupdate"
                    let purchaseResult = verifySubscription(ofType: .autoRenewable, productId: productId, inReceipt: receipt)
                    switch purchaseResult {
                    case .purchased(let expiryDate, let items):
                        promise(.success(true))
                    case .expired(let expiryDate, let items):
                        promise(.success(false))
                    case .notPurchased:
                        promise(.success(false))
                    }
                case .error(let error):
                    promise(.failure(error))
                }
            })
        }
        .eraseToAnyPublisher()
    }
}

extension ReceiptError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noReceiptData:
            return "No valid receipt data."
        case .noRemoteData:
            return "No valid remote data."
        case .requestBodyEncodeError(let error):
            return "Request body could not encoded."
        case .networkError(let error):
            return "Network error."
        case .jsonDecodeError(let string):
            return "JSON Decoding error"
        case .receiptInvalid(let receipt, let status):
            return "Invalid receipt \(status.rawValue)"
        }
    }
    
    public var failureReason: String? {
        return "よくわからないっピ"
    }
}

extension SKError: LocalizedError {
    public var errorDescription: String? {
        return self._nsError.localizedFailureReason
    }
    
    public var failureReason: String? {
        return self._nsError.localizedFailureReason
    }
}
