//
//  Stage.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/02.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

enum StageType: Int, CaseIterable {
    var id: Int { rawValue }
    public enum Package {
        public static let namespace = "Stage"
        public static let version = "1.0.0"
    }
    
    case shakeup    = 5000
    case shakeship  = 5001
    case shakehouse = 5002
    case shakelift  = 5003
    case shakeride  = 5004
    
    public var imageName: String {
        "\(Package.namespace)/\(rawValue)"
    }
    
    var localizedName: String {
        switch self {
        case .shakeup:
            return "Spawning Grounds".localized
        case .shakeship:
            return "Marooner's Bay".localized
        case .shakehouse:
            return "Lost Outpost".localized
        case .shakelift:
            return "Salmonid Smokeyard".localized
        case .shakeride:
            return "Ruins of Ark Polaris".localized
        }
    }
}

extension Image {
    init(_ symbol: StageType) {
        self.init(symbol.imageName, bundle: .main)
    }
    
    init(stageId: Int) {
        self.init(StageType(rawValue: stageId)!)
    }
}
