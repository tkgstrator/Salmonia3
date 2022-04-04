//
//  Text.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/24.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI
import SplatNet2

extension Text {
    init(_ grade: GradeId?) {
        self.init(grade.gradeName)
    }
    
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
    
    init(_ value: StageId) {
        self.init(value.key.stageName)
    }
    
    init(_ value: EventId) {
        self.init(value.key.rawValue)
    }

    init(_ value: WaterId) {
        self.init(value.key.rawValue)
    }
}

extension EventId {
    var key: EventKey {
        switch self {
        case .waterLevels:
            return .waterLevels
        case .rush:
            return .rush
        case .goldieSeeking:
            return .goldieSeeking
        case .griller:
            return .griller
        case .fog:
            return .fog
        case .theMothership:
            return .theMothership
        case .cohockCharge:
            return .cohockCharge
        }
    }
}

extension WaterId {
    var key: WaterKey {
        switch self {
        case .low:
            return .low
        case .normal:
            return .normal
        case .high:
            return .high
        }
    }
}

fileprivate extension Optional where Wrapped == GradeId {
    var gradeName: String {
        switch self {
            case .profreshional:
                return "Profreshional"
            case .overachiver:
                return "Over achiver"
            case .gogetter:
                return "Go getter"
            case .parttimer:
                return "Part timer"
            case .apparentice:
                return "Apparentice"
            case .intern:
                return "Intern"
            case .none:
                return "Intern"
        }
    }
}

fileprivate extension StageKey {
    var stageName: String {
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

extension StageId {
    var key: StageKey {
        switch self {
        case .shakeup:
            return .shakeup
        case .shakeship:
            return .shakeship
        case .shakehouse:
            return .shakehouse
        case .shakelift:
            return .shakelift
        case .shakeride:
            return .shakeride
        }
    }
}
