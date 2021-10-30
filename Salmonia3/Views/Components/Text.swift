//
//  Text.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/24.
//

import Foundation
import SwiftUI

extension Text {
    init(_ value: Int?) {
        if let value = value {
            self.init("\(value)")
        } else {
            self.init("-")
        }
    }
    
    init(_ value: Int) {
        self.init("\(value)")
    }
}
