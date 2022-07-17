//
//  Defeated.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/02.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SplatNet2

extension StatsModel {
    class Defeated: StatsScoreType {
        let id: UUID = UUID()
        let score: Float
        let other: Float
        let bossType: BossId
        
        internal init<T: BinaryFloatingPoint>(score: T?, other: T?, bossType: BossId) {
            self.bossType = bossType
            self.score = {
                guard let score = score else {
                    return .zero
                }
                return Float(score)
            }()
            self.other = {
                guard let other = other else {
                    return .zero
                }
                return Float(other)
            }()
        }
    }
}
