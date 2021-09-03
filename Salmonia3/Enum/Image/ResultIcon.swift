//
//  ResultIcon.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/04.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

enum ResultIcon: String, CaseIterable {
    public enum Package {
        public static let namespace = "ResultIcon"
        public static let version = "1.0.0"
    }
    
    case dot    = "dot"
    case rescue = "rescue"
    case death  = "death"

    public var imageName: String {
        "\(Package.namespace)/\(rawValue)"
    }
}

extension Image {
    init(_ symbol: ResultIcon) {
        self.init(symbol.imageName, bundle: .main)
    }
}
