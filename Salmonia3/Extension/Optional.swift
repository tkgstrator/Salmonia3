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
    var intValue: Int {
        return self == nil ? 0 : self!
    }
}

extension RealmOptional where Value == Int {
    var intValue: Int {
        return self.value == nil ? 0 : self.value!
    }
}
