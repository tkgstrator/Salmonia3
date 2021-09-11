//
//  EventType.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/07.
//  Copyright © 2021 Magi Corporation. All rights reserved.
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
    
    var eventName: String {
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
    
    var localizedName: String {
        self.eventName.localized
    }
}
