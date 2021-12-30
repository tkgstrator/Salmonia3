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
    init(_ symbol: SalmonidType) {
        self.init(symbol.imageName, bundle: .main)
    }
    
    /// オオモノ画像
    init(salmonId: Int) {
        self.init(SalmonidType(rawValue: salmonId)!)
    }
    
    /// ブキ画像
    init(_ weaponType: WeaponType) {
        self.init("Weapon/\(weaponType.rawValue)", bundle: .main)
    }
    
    /// ステージ画像
    init(_ stageId: Schedule.StageId) {
        self.init("Stage/\(stageId.rawValue)", bundle: .main)
    }
    
    /// ステージ画像
    init(_ stageId: StageType.StageId) {
        self.init("Stage/\(stageId.rawValue)", bundle: .main)
    }
    
    /// スペシャル画像
    init(_ specialId: SpecialId) {
        self.init("Special/\(specialId.rawValue)", bundle: .main)
    }
}
