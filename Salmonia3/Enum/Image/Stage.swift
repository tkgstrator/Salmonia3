//
//  Stage.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/02.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

enum Stage: String, CaseIterable {
    public enum Package {
        public static let namespace = "Stage"
        public static let version = "1.0.0"
    }
    
    case shakeup    = "5000"
    case shakeship  = "5001"
    case shakehouse = "5002"
    case shakelift  = "5003"
    case shakeride  = "5004"
    
    public var imageName: String {
        "\(Package.namespace)/\(rawValue)"
    }
    
    var name: String {
        switch self {
        case .shakeup:
            return "Spawning Grounds"
        case .shakeship:
            return "Marooner's Bay"
        case .shakehouse:
            return "Lost Outpost"
        case .shakelift:
            return "Salmonid Smokeyard"
        case .shakeride:
            return "Ruins of Ark Polaris"
        }
    }
}

extension Stage {
    init?(rawValue: Int) {
        self.init(rawValue: String(rawValue))
    }
}

extension Image {
    init(_ symbol: Weapon) {
        self.init(symbol.imageName, bundle: .main)
    }

    init(weaponId: Int) {
        self.init(Weapon(rawValue: String(weaponId))!)
    }
}
