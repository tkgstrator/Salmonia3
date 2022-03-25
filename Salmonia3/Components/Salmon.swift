//
//  Salmon.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/24.
//  
//

import Foundation
import SwiftUI

struct Salmon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + 0.26395 * rect.width, y: rect.minY + 0.00305 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.04351 * rect.width, y: rect.minY + 0.38644 * rect.height), control1: CGPoint(x: rect.minX + 0.17887 * rect.width, y: rect.minY + 0.02117 * rect.height), control2: CGPoint(x: rect.minX + 0.08889 * rect.width, y: rect.minY + 0.17767 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.02471 * rect.width, y: rect.minY + 0.99267 * rect.height), control1: CGPoint(x: rect.minX + -0.00513 * rect.width, y: rect.minY + 0.61018 * rect.height), control2: CGPoint(x: rect.minX + -0.01526 * rect.width, y: rect.minY + 0.93710 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.03000 * rect.width, y: rect.minY + 1.00000 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.48145 * rect.width, y: rect.minY + 0.99910 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.93290 * rect.width, y: rect.minY + 0.99820 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.93988 * rect.width, y: rect.minY + 0.98872 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 1.00000 * rect.width, y: rect.minY + 0.61220 * rect.height), control1: CGPoint(x: rect.minX + 0.97437 * rect.width, y: rect.minY + 0.94192 * rect.height), control2: CGPoint(x: rect.minX + 1.00005 * rect.width, y: rect.minY + 0.78110 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.96574 * rect.width, y: rect.minY + 0.41777 * rect.height), control1: CGPoint(x: rect.minX + 0.99997 * rect.width, y: rect.minY + 0.50616 * rect.height), control2: CGPoint(x: rect.minX + 0.98960 * rect.width, y: rect.minY + 0.44729 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.79295 * rect.width, y: rect.minY + 0.40929 * rect.height), control1: CGPoint(x: rect.minX + 0.96077 * rect.width, y: rect.minY + 0.41160 * rect.height), control2: CGPoint(x: rect.minX + 0.95208 * rect.width, y: rect.minY + 0.41118 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.61597 * rect.width, y: rect.minY + 0.40122 * rect.height), control1: CGPoint(x: rect.minX + 0.64015 * rect.width, y: rect.minY + 0.40748 * rect.height), control2: CGPoint(x: rect.minX + 0.62456 * rect.width, y: rect.minY + 0.40678 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.48497 * rect.width, y: rect.minY + 0.21419 * rect.height), control1: CGPoint(x: rect.minX + 0.57362 * rect.width, y: rect.minY + 0.37382 * rect.height), control2: CGPoint(x: rect.minX + 0.54050 * rect.width, y: rect.minY + 0.32654 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.30118 * rect.width, y: rect.minY + 0.00291 * rect.height), control1: CGPoint(x: rect.minX + 0.41753 * rect.width, y: rect.minY + 0.07777 * rect.height), control2: CGPoint(x: rect.minX + 0.36421 * rect.width, y: rect.minY + 0.01647 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.26395 * rect.width, y: rect.minY + 0.00305 * rect.height), control1: CGPoint(x: rect.minX + 0.28307 * rect.width, y: rect.minY + -0.00099 * rect.height), control2: CGPoint(x: rect.minX + 0.28290 * rect.width, y: rect.minY + -0.00099 * rect.height))
//        path.close()
//        path.usesEvenOddFillRule = true
//        fillColor.setFill()
//        path.fill()
        return path
    }
}

struct Salmon_Previews: PreviewProvider {
    static var previews: some View {
        Salmon()
            .padding()
            .frame(width: 400, height: 120, alignment: .center)
    }
}
