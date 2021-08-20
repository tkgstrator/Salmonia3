//
//  Optional.swift
//  Salmonia3
//
//  Created by tkgstrator on 3/14/21.
//

import Foundation
import RealmSwift

extension Optional where Wrapped == String {
    var stringValue: String {
        if let value = self {
            return value
        }
        return "-"
    }
}

extension Optional where Wrapped == Int {
    var stringValue: String {
        if let value = self {
            return String(value)
        }
        return ""
    }
    
    var intValue: Int {
        if let value = self {
            return value
        }
        return 0
    }
}

extension Optional where Wrapped == Bool {
    var stringValue: String {
        if let value = self {
            return value ? "ENABLED".localized : "DISABLED".localized
        }
        return "-"
    }
}

extension Optional where Wrapped == Double {
    var stringValue: String {
        if let value = self {
            return String(value.round)
        }
        return "-"
    }
    
    var doubleValue: Double {
        if let value = self {
            return value
        }
        return 0.0
    }
}

extension Optional where Wrapped == Any {
    var stringValue: String {
        switch self {
        case is Int:
            return (self as? Int).stringValue
        case is Bool:
            return (self as? Bool).stringValue
        case is Double:
            return (self as? Double).stringValue
        case is String:
            return (self as? String).stringValue
        default:
            return "-"
        }
    }
}

fileprivate extension Double {
    var round: Double {
        return Double(Int(self * 100)) / Double(100)
    }
}
