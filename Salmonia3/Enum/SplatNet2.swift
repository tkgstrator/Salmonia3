//
//  SplatNet2.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/05/15.
//

import Foundation

enum EventType: Int, CaseIterable, Identifiable {
    var id: Int { rawValue }
    case noevent    = 0
    case rush       = 1
    case goldie     = 2
    case griller    = 3
    case mothership = 4
    case fog        = 5
    case cohock     = 6
}

enum WaterLevel: Int, CaseIterable, Identifiable {
    var id: Int { rawValue }
    case low        = 0
    case normal     = 1
    case high       = 2
}

extension EventType {
    var eventType: String {
        switch self {
        case .noevent:
            return "water-levels"
        case .rush:
            return "rush"
        case .goldie:
            return "goldie-seeking"
        case .griller:
            return "griller"
        case .mothership:
            return "the-mothership"
        case .fog:
            return "fog"
        case .cohock:
            return "cohock-charge"
        }
    }
}

extension WaterLevel {
    var waterLevel: String {
        switch self {
        case .low:
            return "low"
        case .normal:
            return "normal"
        case .high:
            return "high"
        }
    }
}

