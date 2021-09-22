//
//  AnglePair.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/22.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI

struct SpecialAnglePair: Hashable {
    let specialId: Int
    let startAngle: Angle
    let endAngle: Angle
    let offsetAngle: CGFloat
    
    internal init(specialId: Int, startAngle: Angle, endAngle: Angle, offsetAngle: CGFloat) {
        self.specialId = specialId
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.offsetAngle = offsetAngle
    }
}

struct AnglePair: Hashable {
    let startAngle: Angle
    let endAngle: Angle
    let offsetAngle: CGFloat
    
    internal init(startAngle: Angle, endAngle: Angle, offsetAngle: CGFloat) {
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.offsetAngle = offsetAngle
    }
}

extension Array where Element == CoopShiftStats.ResultSpecial {
    var anglePairs: [SpecialAnglePair] {
        let totalValue: Int = self.map({ $0.count }).reduce(0, +)
        var startAngle: Angle = .degrees(-90)
        var angles: [SpecialAnglePair] = []
        
        for special in self {
            let value = special.count
            if value >= 1 {
                let endAngle = startAngle + .degrees(360 * CGFloat(value) / CGFloat(totalValue))
                let offsetAngle = CGFloat(((startAngle + endAngle) / 2).degrees / 180 * .pi)
                angles.append(SpecialAnglePair(specialId: special.specialId, startAngle: startAngle, endAngle: endAngle, offsetAngle: offsetAngle))
                startAngle = endAngle
            }
        }
        return angles
    }
}
