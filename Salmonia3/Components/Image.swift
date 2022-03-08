//
//  Image.swift
//  Salmonia3
//
//  Created by devonly on 2021/11/23.
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
}
