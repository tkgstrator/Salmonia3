//
//  ChartView.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/22.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI

struct PieChartView: View {
    let chartColors: [Color] = [.easternblue, .safetyorange, .dimgray, .citrus]
    let values: [Int]
    let jobNum: Int
    let angles: [AnglePair]
    let caption: String

    init(_ values: [Int], caption: String = "") {
        self.values = values
        self.jobNum = values.reduce(0, +)
        self.angles = values.anglePairs
        self.caption = caption
    }
    
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
                    Text(caption)
                    Text("\(jobNum)回")
                })
                .splatfont2(.seashell, size: 20)
            )
    }
    
    var cirlceLayer: some View {
        ZStack(alignment: .center, content: {
            ForEach(angles, id:\.self) { angle in
                Pie(startAngle: angle.startAngle, endAngle: angle.endAngle)
                    .fill(chartColors[angles.firstIndex(of: angle)!])
            }
        })
    }
}

extension Array where Element == Int {
    var anglePairs: [AnglePair] {
        let totalValue: Int = self.reduce(0, +)
        var startAngle: Angle = .degrees(-90)
        var angles: [AnglePair] = []
        
        for value in self {
            if value >= 1 {
                let endAngle = startAngle + .degrees(360 * CGFloat(value) / CGFloat(totalValue))
                let offsetAngle = CGFloat(((startAngle + endAngle) / 2).degrees / 180 * .pi)
                angles.append(AnglePair(startAngle: startAngle, endAngle: endAngle, offsetAngle: offsetAngle))
                startAngle = endAngle
            }
        }
        return angles
    }
}
