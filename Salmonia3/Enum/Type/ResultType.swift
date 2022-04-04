//
//  ResultType.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/24.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftUI

enum ResultType: String, CaseIterable, PersistableEnum, Codable {
    case power
    case golden
    case help
    case rescue
    
    var id: String { rawValue }
    
    public enum Package {
        public static let namespace = "Result"
        public static let version = "1.0.0"
    }
    
    fileprivate var imageName: String {
        "\(Package.namespace)/\(self.rawValue)"
    }
}

extension Image {
    init(_ symbol: ResultType) {
        self.init(symbol.imageName, bundle: .main)
    }
}
