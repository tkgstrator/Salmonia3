//
//  Wave.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/03.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

enum WaterLevel: Int, CaseIterable, Identifiable {
    var id: Int { rawValue }
    public enum Package {
        public static let namespace = "Wave"
        public static let version = "1.0.0"
    }
    
    case low    = 0
    case middle = 1
    case high   = 2
    
    var localizedName: String {
        waterName.localized
    }
    
    var waterName: String {
        switch self {
            case .low:
                return "low"
            case .middle:
                return "normal"
            case .high:
                return "high"
        }
    }
    
    public var imageName: String {
        "\(Package.namespace)/\(waterName)"
    }
}

extension Image {
    init(_ symbol: WaterLevel) {
        self.init(symbol.imageName, bundle: .main)
    }
    
    init(waterLevel: Int) {
        self.init(WaterLevel(rawValue: waterLevel)!)
    }
}
