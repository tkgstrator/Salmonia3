//
//  Error.swift
//  Salmonia3
//
//  Created by Devonly on 3/16/21.
//

import Foundation

enum APPError: Error {
    case unknown
    case upgrade
    case unauthorized
    case forbidden
    case badrequest
    case requests
    case method
    case invalid
    case expired
    case empty
    case unavailable
    case nodata
    case outdate
    case realm
}

extension APPError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "ERROR_UNKNOWN"
        case .upgrade:
            return "ERROR_UPGRADE"
        case .unauthorized:
            return "ERROR_UNAUTHORIZED"
        case .forbidden:
            return "ERROR_FORBIDDEN"
        case .badrequest:
            return "ERROR_BADREQUEST"
        case .requests:
            return "ERROR_MANY_REQUESTS"
        case .method:
            return "ERROR_METHOD"
        case .invalid:
            return "ERROR_INVALID"
        case .expired:
            return "ERROR_EXPIRED"
        case .empty:
            return "ERROR_EMPTY"
        case .unavailable:
            return "ERROR_UNAVAILABLE"
        case .nodata:
            return "ERROR_NODATA"
        case .outdate:
            return "ERROR_ACCOUNT_OUTDATE"
        case .realm:
            return "ERROR_REALM_DATABASE"
        }
    }
}
