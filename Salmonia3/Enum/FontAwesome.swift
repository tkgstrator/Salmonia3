//
//  FontAwesome.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/23.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI

enum FontAwesome: String, CaseIterable {
    public enum Package {
        public static let namespace = "FontAwesome"
        public static let version = "1.0.0"
    }
    
    case home
    case gear
    case calendar
    case newspaper
    case user


    public var imageName: String {
        "\(Package.namespace)/\(rawValue)"
    }
}

extension Image {
    init(_ symbol: FontAwesome) {
        self.init(symbol.imageName, bundle: .main)
    }
}
