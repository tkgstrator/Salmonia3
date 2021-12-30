//
//  Pie.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/24.
//

import Foundation
import SwiftUI

struct Pie: Shape {
    let startAngle: Angle
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = min(center.x, center.y)
        let path = Path { path in
            path.addArc(center: center,
                        radius: radius,
                        startAngle: startAngle,
                        endAngle: endAngle,
                        clockwise: false)
            path.addLine(to: center)
        }
        return path
    }
}
