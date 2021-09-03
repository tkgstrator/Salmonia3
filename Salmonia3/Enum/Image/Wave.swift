//
//  Wave.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/03.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

enum Wave: String, CaseIterable {
    public enum Package {
        public static let namespace = "Wave"
        public static let version = "1.0.0"
    }
    
    case low    = "low"
    case middle = "middle"
    case high   = "high"
    
    public var imageName: String {
        "\(Package.namespace)/\(rawValue)"
    }
}

extension Image {
    init(_ symbol: Wave) {
        self.init(symbol.imageName, bundle: .main)
    }
    
    init(waterLevel: Int) {
        switch waterLevel {
        case 0:
            self.init(Wave.low)
        case 1:
            self.init(Wave.middle)
        case 2:
            self.init(Wave.high)
        default:
            self.init(Wave.middle)
        }
    }
}
