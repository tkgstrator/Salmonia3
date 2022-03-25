//
//  Wavecard.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/25.
//  
//

import SwiftUI

struct Wavecard: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + 0.59950 * rect.width, y: rect.minY + 0.00000 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.59950 * rect.width, y: rect.minY + 0.01800 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.59960 * rect.width, y: rect.minY + 0.01803 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.61119 * rect.width, y: rect.minY + 0.03697 * rect.height), control1: CGPoint(x: rect.minX + 0.60882 * rect.width, y: rect.minY + 0.02048 * rect.height), control2: CGPoint(x: rect.minX + 0.61401 * rect.width, y: rect.minY + 0.02896 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.58940 * rect.width, y: rect.minY + 0.04705 * rect.height), control1: CGPoint(x: rect.minX + 0.60837 * rect.width, y: rect.minY + 0.04499 * rect.height), control2: CGPoint(x: rect.minX + 0.59861 * rect.width, y: rect.minY + 0.04950 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.57781 * rect.width, y: rect.minY + 0.02810 * rect.height), control1: CGPoint(x: rect.minX + 0.58018 * rect.width, y: rect.minY + 0.04460 * rect.height), control2: CGPoint(x: rect.minX + 0.57499 * rect.width, y: rect.minY + 0.03612 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.58969 * rect.width, y: rect.minY + 0.01795 * rect.height), control1: CGPoint(x: rect.minX + 0.57954 * rect.width, y: rect.minY + 0.02319 * rect.height), control2: CGPoint(x: rect.minX + 0.58401 * rect.width, y: rect.minY + 0.01937 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.58950 * rect.width, y: rect.minY + 0.00000 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.41045 * rect.width, y: rect.minY + 0.00000 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.41045 * rect.width, y: rect.minY + 0.01800 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.41055 * rect.width, y: rect.minY + 0.01803 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.42214 * rect.width, y: rect.minY + 0.03697 * rect.height), control1: CGPoint(x: rect.minX + 0.41977 * rect.width, y: rect.minY + 0.02048 * rect.height), control2: CGPoint(x: rect.minX + 0.42496 * rect.width, y: rect.minY + 0.02896 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.40035 * rect.width, y: rect.minY + 0.04705 * rect.height), control1: CGPoint(x: rect.minX + 0.41932 * rect.width, y: rect.minY + 0.04499 * rect.height), control2: CGPoint(x: rect.minX + 0.40956 * rect.width, y: rect.minY + 0.04950 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.38876 * rect.width, y: rect.minY + 0.02810 * rect.height), control1: CGPoint(x: rect.minX + 0.39113 * rect.width, y: rect.minY + 0.04460 * rect.height), control2: CGPoint(x: rect.minX + 0.38594 * rect.width, y: rect.minY + 0.03612 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.40064 * rect.width, y: rect.minY + 0.01795 * rect.height), control1: CGPoint(x: rect.minX + 0.39049 * rect.width, y: rect.minY + 0.02319 * rect.height), control2: CGPoint(x: rect.minX + 0.39496 * rect.width, y: rect.minY + 0.01937 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.40045 * rect.width, y: rect.minY + 0.00000 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.00000 * rect.width, y: rect.minY + 0.00000 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.00000 * rect.width, y: rect.minY + 1.00000 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 1.00000 * rect.width, y: rect.minY + 1.00000 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 1.00000 * rect.width, y: rect.minY + 0.00000 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.59950 * rect.width, y: rect.minY + 0.00000 * rect.height))
        path.closeSubpath()
        return path
    }
}

struct Wavecard_Previews: PreviewProvider {
    static var previews: some View {
        Wavecard()
    }
}
