//
//  StageType.swift
//  Salmonia3
//
//  Created by tkgstrator on 3/16/21.
//

import Foundation
import SwiftUI

enum StageType: Int, CaseIterable {
    case shakeup    = 5000
    case shakeship  = 5001
    case shakehouse = 5002
    case shakelift  = 5003
    case shakeride  = 5004
}

extension StageType {
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
