//
//  SpecialProb.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/02.
//

import Foundation
import SplatNet2

extension StatsModel {
    struct SpecialProb {
        internal init(specialId: SpecialId, prob: Double) {
            self.specialId = specialId
            self.prob = prob
        }
        
        let specialId: SpecialId
        let prob: Double
    }
    
}
