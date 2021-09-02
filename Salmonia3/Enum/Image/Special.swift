//
//  Special.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/02.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

enum Special: String, CaseIterable {
    public enum Package {
        public static let namespace = "Special"
        public static let version = "1.0.0"
    }
    
    case bombpitcher    = "2"
    case stingray       = "7"
    case inkjet         = "8"
    case splashdown     = "9"

    public var imageName: String {
        "\(Package.namespace)/\(rawValue)"
    }
    
    var name: String {
        switch self {
        case .bombpitcher:
            return "Bomb pitcher"
        case .stingray:
            return "Sting ray"
        case .inkjet:
            return "Inkjet"
        case .splashdown:
            return "Splashdown"
        }
    }
}

extension Image {
    init(_ symbol: Special) {
        self.init(symbol.imageName, bundle: .main)
    }
    
    init(specialId: Int) {
        self.init(Special(rawValue: String(specialId))!)
    }
}
