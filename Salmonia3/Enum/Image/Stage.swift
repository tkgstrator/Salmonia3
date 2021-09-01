//
//  Stage.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/02.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

enum IconStage: String, CaseIterable {
    public enum Package {
        public static let namespace = "Stage"
        public static let version = "1.0.0"
    }
    
    case shakeup    = "5000"
    case shakeship  = "5001"
    case shakehouse = "5002"
    case shakelift  = "5003"
    case shakeride  = "5004"
    
    public var imageName: String {
        "\(Package.namespace)/\(rawValue)"
    }
}
