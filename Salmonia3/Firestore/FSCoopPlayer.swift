//
//  FSCoopPlayer.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/18.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SplatNet2
import SalmonStats

public struct FSCoopPlayer: Codable {
    let pid: String
    let name: String?
    let goldenIkuraNum: Int
    let ikuraNum: Int
    let bossKillCounts: [Int]
    let special: Int
    let helpCount: Int
    let deadCount: Int
    let weaponList: [Int]
    let specialCounts: [Int]
    
    public init(player: CoopResult.PlayerResult) {
        self.pid = player.pid
        self.name = player.name
        self.goldenIkuraNum = player.goldenIkuraNum
        self.ikuraNum = player.ikuraNum
        self.bossKillCounts = player.bossKillCounts.sortedValue()
        self.special = player.special.id.rawValue
        self.helpCount = player.helpCount
        self.deadCount = player.deadCount
        self.weaponList = player.weaponList.map({ Int($0.id.id)! })
        self.specialCounts = player.specialCounts
    }
}
