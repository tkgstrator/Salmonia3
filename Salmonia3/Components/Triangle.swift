//
//  Triangle.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/05.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path({ path in
            let width: CGFloat = min(rect.maxX, rect.maxY)
            path.move(to: CGPoint(x: width / 2, y: 0))
            path.addLine(to: CGPoint(x: width, y: width))
            path.addLine(to: CGPoint(x: 0, y: width))
            path.closeSubpath()
        })
    }
}
