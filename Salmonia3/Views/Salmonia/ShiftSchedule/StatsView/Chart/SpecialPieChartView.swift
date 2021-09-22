//
//  PieChartView.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/22.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI

struct SpecialPieChartView: View {
    let chartColors: [Color] = [.safetyorange, .easternblue, .dimgray, .blackrussian]
    let specials: [CoopShiftStats.ResultSpecial]
    let jobNum: Int
    let angles: [SpecialAnglePair]

    init(specials: [CoopShiftStats.ResultSpecial]) {
        self.specials = specials
        self.jobNum = specials.map({ $0.count }).reduce(0, +)
        self.angles = specials.anglePairs
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
                    Text("今回のバイト回数")
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
            ForEach(angles, id:\.self) { angle in
                Image(specialId: angle.specialId)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 36, height: 36)
                    .offset(x: 80 * cos(angle.offsetAngle), y: 80 * sin(angle.offsetAngle))
            }
        })
    }
}
