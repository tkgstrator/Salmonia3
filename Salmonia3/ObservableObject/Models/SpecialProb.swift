//
//  SpecialProb.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/02.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SplatNet2

extension StatsModel {
    struct SpecialProb {
        internal init(specialId: SpecialId, prob: Double, count: Int) {
            self.specialId = specialId
            self.prob = prob
            self.count = count
        }
        
        let specialId: SpecialId
        let prob: Double
        let count: Int
    }
    
}
