//
//  Error.swift
//  Salmonia3
//
//  Created by tkgstrator on 3/16/21.
//

import Foundation

enum APPError: Error {

}

enum SKError: Int, Error, Identifiable {
    var id: Int { rawValue }
    case unknown
    case clientInvalid
    case paymentCancelled
    case paymentInvalid
    case paymentNotAllowed
    case storeProductNotAvailable
    case cloudServicePermissionDenied
    case cloudServiceNetworkConnectionFailed
    case cloudServiceRevoked
    case noRestoredProduct
}
