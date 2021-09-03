//
//  Salmonid.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/02.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

enum Salmonid: String, CaseIterable {
    public enum Package {
        public static let namespace = "Salmonid"
        public static let version = "1.0.0"
    }
    
    case goldie     = "3"
    case steelhead  = "6"
    case flyfish    = "9"
    case scrapper   = "12"
    case steeleel   = "13"
    case tower      = "14"
    case maws       = "15"
    case griller    = "16"
    case drizzler   = "19"

    public var imageName: String {
        "\(Package.namespace)/\(rawValue)"
    }
    
    var name: String {
        switch self {
        case .goldie:
            return "Goldie"
        case .steelhead:
            return "Steelhead"
        case .flyfish:
            return "Flyfish"
        case .scrapper:
            return "Scrapper"
        case .steeleel:
            return "Steel Eel"
        case .tower:
            return "Tower"
        case .maws:
            return "Maws"
        case .griller:
            return "Griller"
        case .drizzler:
            return "Drizzler"
        }
    }
    
    // 指定されたオオモノシャケのインデックスを返す
    var index: Int {
        return Salmonid.allCases.firstIndex(of: self)!
    }
}

extension Image {
    init(_ symbol: Salmonid) {
        self.init(symbol.imageName, bundle: .main)
    }
    
    init(salmonId: Int) {
        self.init(Salmonid(rawValue: String(salmonId))!)
    }

    init(salmonId: String) {
        self.init(Salmonid(rawValue: salmonId)!)
    }
}
