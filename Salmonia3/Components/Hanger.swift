//
//  Hanger.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/31.
//  
//

import SwiftUI

struct Hanger: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + 0.52943 * rect.width, y: rect.minY + 0.00000 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.52943 * rect.width, y: rect.minY + -0.00000 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.52515 * rect.width, y: rect.minY + 0.00277 * rect.height), control1: CGPoint(x: rect.minX + 0.52736 * rect.width, y: rect.minY + -0.00000 * rect.height), control2: CGPoint(x: rect.minX + 0.52558 * rect.width, y: rect.minY + 0.00116 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.51953 * rect.width, y: rect.minY + 0.02372 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.51952 * rect.width, y: rect.minY + 0.02373 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.50929 * rect.width, y: rect.minY + 0.03060 * rect.height), control1: CGPoint(x: rect.minX + 0.51841 * rect.width, y: rect.minY + 0.02759 * rect.height), control2: CGPoint(x: rect.minX + 0.51423 * rect.width, y: rect.minY + 0.03039 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.48362 * rect.width, y: rect.minY + 0.03060 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.48362 * rect.width, y: rect.minY + 0.03060 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.47410 * rect.width, y: rect.minY + 0.02298 * rect.height), control1: CGPoint(x: rect.minX + 0.47836 * rect.width, y: rect.minY + 0.03060 * rect.height), control2: CGPoint(x: rect.minX + 0.47410 * rect.width, y: rect.minY + 0.02719 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.47410 * rect.width, y: rect.minY + 0.01800 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.48462 * rect.width, y: rect.minY + 0.01424 * rect.height), control1: CGPoint(x: rect.minX + 0.47410 * rect.width, y: rect.minY + 0.01422 * rect.height), control2: CGPoint(x: rect.minX + 0.47970 * rect.width, y: rect.minY + 0.01238 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.49405 * rect.width, y: rect.minY + 0.01798 * rect.height), control1: CGPoint(x: rect.minX + 0.48803 * rect.width, y: rect.minY + 0.01552 * rect.height), control2: CGPoint(x: rect.minX + 0.49082 * rect.width, y: rect.minY + 0.01664 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.50080 * rect.width, y: rect.minY + 0.01498 * rect.height), control1: CGPoint(x: rect.minX + 0.49655 * rect.width, y: rect.minY + 0.01898 * rect.height), control2: CGPoint(x: rect.minX + 0.49905 * rect.width, y: rect.minY + 0.01632 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.50080 * rect.width, y: rect.minY + 0.01498 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.50097 * rect.width, y: rect.minY + 0.01178 * rect.height), control1: CGPoint(x: rect.minX + 0.50186 * rect.width, y: rect.minY + 0.01410 * rect.height), control2: CGPoint(x: rect.minX + 0.50193 * rect.width, y: rect.minY + 0.01273 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.49395 * rect.width, y: rect.minY + 0.00154 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.49395 * rect.width, y: rect.minY + 0.00154 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.49033 * rect.width, y: rect.minY + -0.00000 * rect.height), control1: CGPoint(x: rect.minX + 0.49314 * rect.width, y: rect.minY + 0.00058 * rect.height), control2: CGPoint(x: rect.minX + 0.49178 * rect.width, y: rect.minY + -0.00000 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.00000 * rect.width, y: rect.minY + 0.00000 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.00000 * rect.width, y: rect.minY + 1.00000 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 1.00000 * rect.width, y: rect.minY + 1.00000 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 1.00000 * rect.width, y: rect.minY + 0.00000 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.52943 * rect.width, y: rect.minY + 0.00000 * rect.height))
        path.closeSubpath()
        return path
    }
}

struct Hanger_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader(content: { geometry in
            let height: CGFloat = geometry.width * 225 / 400
            Hanger()
                .aspectRatio(400/500, contentMode: .fill)
                .frame(width: geometry.width, height: height, alignment: .top)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 6))
        })
    }
}
