//
//  WeaponProb.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/02.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SplatNet2

extension StatsModel {
    class WeaponProb {
        internal init(weaponType: WeaponType, prob: Double) {
            self.weaponType = weaponType
            self.prob = prob
        }
        
        let weaponType: WeaponType
        let prob: Double
    }
}
