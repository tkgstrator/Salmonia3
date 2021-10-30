//
//  EventType.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/07.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift

enum EventType: Int, CaseIterable, Identifiable, PersistableEnum, Codable {
    case noevent    = 0
    case rush       = 1
    case goldie     = 2
    case griller    = 3
    case mothership = 4
    case fog        = 5
    case cohock     = 6

    var id: Int { rawValue }

    var localizedName: String {
        switch self {
        case .noevent:
            return "water-levels".localized
        case .rush:
            return "rush".localized
        case .goldie:
            return "goldie-seeking".localized
        case .griller:
            return "griller".localized
        case .mothership:
            return "the-mothership".localized
        case .fog:
            return "fog".localized
        case .cohock:
            return "cohock-charge".localized
        }
    }
}
