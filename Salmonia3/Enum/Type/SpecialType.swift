//
//  Special.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/02.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftUI

enum SpecialType: Int, CaseIterable, PersistableEnum {
    case bombpitcher    = 2
    case stingray       = 7
    case inkjet         = 8
    case splashdown     = 9
    
    var id: Int { rawValue }
   
    public enum Package {
        public static let namespace = "Special"
        public static let version = "1.0.0"
    }

    public var imageName: String {
        "\(Package.namespace)/\(rawValue)"
    }
    
    var localizedName: String {
        switch self {
        case .bombpitcher:
            return "Bomb pitcher".localized
        case .stingray:
            return "Sting ray".localized
        case .inkjet:
            return "Inkjet".localized
        case .splashdown:
            return "Splashdown".localized
        }
    }
}

extension Image {
    init(_ symbol: SpecialType) {
        self.init(symbol.imageName, bundle: .main)
    }
    
    init(specialId: Int) {
        self.init(SpecialType(rawValue: specialId)!)
    }
}
