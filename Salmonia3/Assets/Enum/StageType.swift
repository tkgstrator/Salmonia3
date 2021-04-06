//
//  StageType.swift
//  Salmonia3
//
//  Created by Devonly on 3/16/21.
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

    var md5: String {
        switch self {
        case .shakeup:
            return "00963b1057a02a9ca5b3492aecc38f63"
        case .shakeship:
            return "0012a0d09f26225edde5fe2edc3fc015"
        case .shakehouse:
            return "dd2e2e1c801d4cf4322736b9aadd91f6"
        case .shakelift:
            return "49ca412e830695b6aeb26d74f898a7a5"
        case .shakeride:
            return "97d1cf22ecf5769735fd66477ba58ab8"
        }
    }
}
