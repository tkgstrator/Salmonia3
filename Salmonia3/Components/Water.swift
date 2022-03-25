//
//  Water.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/25.
//  
//

import SwiftUI

struct Water: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + 0.90099 * rect.width, y: rect.minY + 0.03955 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.80059 * rect.width, y: rect.minY + 0.00000 * rect.height), control1: CGPoint(x: rect.minX + 0.85069 * rect.width, y: rect.minY + 0.03955 * rect.height), control2: CGPoint(x: rect.minX + 0.85069 * rect.width, y: rect.minY + 0.00000 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.70040 * rect.width, y: rect.minY + 0.03955 * rect.height), control1: CGPoint(x: rect.minX + 0.75050 * rect.width, y: rect.minY + 0.00000 * rect.height), control2: CGPoint(x: rect.minX + 0.75050 * rect.width, y: rect.minY + 0.03955 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.60010 * rect.width, y: rect.minY + 0.00000 * rect.height), control1: CGPoint(x: rect.minX + 0.65030 * rect.width, y: rect.minY + 0.03955 * rect.height), control2: CGPoint(x: rect.minX + 0.65020 * rect.width, y: rect.minY + 0.00000 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.49990 * rect.width, y: rect.minY + 0.03955 * rect.height), control1: CGPoint(x: rect.minX + 0.55000 * rect.width, y: rect.minY + 0.00000 * rect.height), control2: CGPoint(x: rect.minX + 0.55000 * rect.width, y: rect.minY + 0.03955 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.39970 * rect.width, y: rect.minY + 0.00000 * rect.height), control1: CGPoint(x: rect.minX + 0.44980 * rect.width, y: rect.minY + 0.03955 * rect.height), control2: CGPoint(x: rect.minX + 0.44980 * rect.width, y: rect.minY + 0.00000 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.29950 * rect.width, y: rect.minY + 0.03955 * rect.height), control1: CGPoint(x: rect.minX + 0.34960 * rect.width, y: rect.minY + 0.00000 * rect.height), control2: CGPoint(x: rect.minX + 0.34960 * rect.width, y: rect.minY + 0.03955 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.19931 * rect.width, y: rect.minY + 0.00000 * rect.height), control1: CGPoint(x: rect.minX + 0.24941 * rect.width, y: rect.minY + 0.03955 * rect.height), control2: CGPoint(x: rect.minX + 0.24941 * rect.width, y: rect.minY + 0.00000 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.09901 * rect.width, y: rect.minY + 0.03955 * rect.height), control1: CGPoint(x: rect.minX + 0.14921 * rect.width, y: rect.minY + 0.00000 * rect.height), control2: CGPoint(x: rect.minX + 0.14921 * rect.width, y: rect.minY + 0.03955 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.00000 * rect.width, y: rect.minY + 0.00000 * rect.height), control1: CGPoint(x: rect.minX + 0.04881 * rect.width, y: rect.minY + 0.03955 * rect.height), control2: CGPoint(x: rect.minX + 0.04950 * rect.width, y: rect.minY + 0.00064 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.00000 * rect.width, y: rect.minY + 1.00000 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 1.00000 * rect.width, y: rect.minY + 1.00000 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 1.00000 * rect.width, y: rect.minY + 0.00000 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.90099 * rect.width, y: rect.minY + 0.03955 * rect.height), control1: CGPoint(x: rect.minX + 0.95099 * rect.width, y: rect.minY + 0.00064 * rect.height), control2: CGPoint(x: rect.minX + 0.95050 * rect.width, y: rect.minY + 0.03955 * rect.height))
        path.closeSubpath()
        return path
    }
}

struct Water_Previews: PreviewProvider {
    static var previews: some View {
        Water()
    }
}
