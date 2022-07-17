//
//  Image.swift
//  Salmonia3
//
//  Created by devonly on 2021/11/23.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI
import SplatNet2

extension Image {
    /// オオモノ画像
    init(_ symbol: BossId) {
        self.init("SalmonId/\(symbol.rawValue)", bundle: .main)
    }
    
    /// ブキ画像
    init(_ weaponType: WeaponType) {
        self.init("Weapon/\(weaponType.rawValue)", bundle: .main)
    }
    
    /// ステージ画像
    init(_ stageId: StageId) {
        self.init("Stage/\(stageId.rawValue)", bundle: .main)
    }
    
    /// スペシャル画像
    init(_ specialId: SpecialId) {
        self.init("Special/\(specialId.rawValue)", bundle: .main)
    }
    
    /// ランク画像
    init(_ rankId: RankId) {
        self.init("Rank/\(rankId.rawValue)", bundle: .main)
    }

    /// Stickers
    init(_ sticker: StickersType) {
        self.init(sticker.imageName, bundle: .main)
    }
}

enum StickersType: String, CaseIterable {
    enum Package {
        public static let namespace = "Stickers" // Namespaceを指定
        public static let version = "1.0.0"
    }

    case judd       = "Judd"
    case jelonzo    = "Jelonzo"
    case inkling    = "Inkling"
    case party      = "Party"
    case snail      = "Snail"
    case stats      = "Stats"
    case splatted   = "Splatted"
    case squid      = "Squid"
    case flow       = "Flow"
    case lijudd     = "LiJudd"

    public var imageName: String {
        "\(Package.namespace)/\(rawValue)"
    }
}

enum SignInType: String, CaseIterable {
    enum Package {
        public static let namespace = "SplatNet2" // Namespaceを指定
        public static let version = "1.0.0"
    }
    
    case splatnet2      = "SplatNet2"
    case salmonstats    = "SalmonStats"
    case newsalmonstats = "NewSalmonStats"
    
    public var imageName: String {
        "\(Package.namespace)/\(rawValue)"
    }
}
