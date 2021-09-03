//
//  Egg.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/03.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

enum Egg: String, CaseIterable {
    public enum Package {
        public static let namespace = "Egg"
        public static let version = "1.0.0"
    }
    
    case power      = "power"
    case golden     = "golden"

    public var imageName: String {
        "\(Package.namespace)/\(rawValue)"
    }
}

extension Image {
    init(_ symbol: Egg) {
        self.init(symbol.imageName, bundle: .main)
    }
}
