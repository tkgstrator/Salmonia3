//
//  Optional.swift
//  Salmonia3
//
//  Created by Devonly on 3/14/21.
//

import Foundation
import RealmSwift

extension Optional where Wrapped == String {
    var stringValue: String {
        return self == nil ? "-" : self!
    }
}

extension Optional where Wrapped == Int {
    var stringValue: String {
        return self == nil ? "-" : String(self!)
    }
    
    var intValue: Int {
        return self == nil ? 0 : self!
    }
}

extension Optional where Wrapped == Bool {
    var stringValue: String {
        guard let _ = self else { return "-" }
        return self! ? "ENABLED".localized : "DISABLED".localized
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

extension RealmOptional where Value == Int {
    var intValue: Int {
        return self.value == nil ? 0 : self.value!
    }
}

fileprivate extension Double {
    var round: Double {
        return Double(Int(self * 100)) / Double(100)
    }
}
