//
//  Defeated.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/02.
//

import Foundation
import SplatNet2

extension StatsModel {
    class Defeated: StatsType {
        let id: UUID = UUID()
        let score: Float
        let other: Float
        let bossType: BossType.BossId
        
        internal init<T: BinaryFloatingPoint>(score: T?, other: T?, bossType: BossType.BossId) {
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
