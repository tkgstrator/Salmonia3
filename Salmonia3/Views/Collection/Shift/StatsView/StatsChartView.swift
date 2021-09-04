//
//  StatsChartView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/07/24.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI

struct StatsChartView: View {
    @EnvironmentObject var stats: CoopShiftStats

    var body: some View {
        ScrollView {
            PieChartView()
        }
    }
}

struct PieChartView: View {
    let values: [Int] = [10, 20, 30, 40]
    
    var body: some View {
        Circle()
            .strokeBorder(Color.blackrussian, lineWidth: 3)
            .frame(width: 200, height: 200)
            .background(cirlceLayer)
            .overlay(Circle()
                        .fill(Color.blackrussian)
                        .frame(width: 124, height: 124))
            .overlay(
                VStack(alignment: .center, spacing: -20, content: {
                    Text("今回のバイト回数")
                    Text("\(values.reduce(0, +))回")
                })
                .splatfont2(.seashell, size: 20)
            )
            .overlay(specialLayer)
    }
    
    var specialLayer: some View {
        ZStack(alignment: .center, content: {
            ForEach(values.getOffset(), id:\.self) { value in
                Image(specialId: 2)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .offset(x: 80 * cos(value), y: 80 * sin(value))
            }
        })
    }
    
    var cirlceLayer: some View {
        ZStack(alignment: .center, content: {
            ForEach(values.generateAngles(), id:\.self) { anglePair in
                Pie(startAngle: anglePair.startAngle, endAngle: anglePair.endAngle)
                    .fill(Color.random)
            }
        })
    }
}

struct AnglePair: Hashable {
    let startAngle: Angle
    let endAngle: Angle
    
    internal init(startAngle: Angle, endAngle: Angle) {
        self.startAngle = startAngle
        self.endAngle = endAngle
    }
}

struct Pie: Shape {
    let startAngle: Angle
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = min(center.x, center.y)
        let path = Path { path in
            path.addArc(center: center,
                        radius: radius,
                        startAngle: startAngle - .degrees(90),
                        endAngle: endAngle - .degrees(90),
                        clockwise: false)
            path.addLine(to: center)
        }
        return path
    }
}

fileprivate extension Array where Element == Int {
    func getOffset() -> [CGFloat] {
        var angles: [CGFloat] = []
        var currentAngle: Angle = .degrees(-90)
        var tmpAngle: Angle = .degrees(-90)
        let totalValue: Int = self.reduce(0, +)
        
        for value in self {
            tmpAngle = currentAngle + .degrees(360 * CGFloat(value / 2) / CGFloat(totalValue))
            angles.append(CGFloat(tmpAngle.degrees / 180 * .pi))
            currentAngle += .degrees(360 * CGFloat(value) / CGFloat(totalValue))
        }
        print(angles)
        return angles
    }
    
    func generateAngles() -> [AnglePair] {
        let totalValue: Int = self.reduce(0, +)
        var startAngle: Angle = .degrees(0)
        var angles: [AnglePair] = []
        
        for value in self {
            let endAngle = startAngle + .degrees(360 * CGFloat(value) / CGFloat(totalValue))
            angles.append(AnglePair(startAngle: startAngle, endAngle: endAngle))
            startAngle = endAngle
        }
        return angles
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView()
    }
}
