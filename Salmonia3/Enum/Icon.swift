//
//  Icon.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/19.
//

import Foundation
import SwiftUI

enum SFSymbol: String, CaseIterable {
    public enum Package {
        public static let namespace = "Icon"
        public static let version = "1.0.0"
    }
    
    case setting    = "gear"
    case internet   = "network.badge.shield.half.filled"
    case calendar   = "calendar"
    case home       = "house"
    case addaccount = "person.crop.circle.badge.plus"
    case invisible  = "eye.slash"
    case visible    = "eye"
    case refresh    = "arrow.triangle.2.circlepath"
}

extension Image {
    init(_ symbol: SFSymbol) {
        self.init(systemName: symbol.rawValue)
    }
}
