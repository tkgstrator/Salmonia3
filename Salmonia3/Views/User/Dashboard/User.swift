//
//  Dashboard.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/27.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftyChart


extension Dashboard {
    struct BossDefeatedRatio: View {
#if DEBUG
    var defeated: RadarChartStats? = RadarChartStats(
        player: RadarChartSet(data: Array(repeating: 1, count: 9), caption: "", color: .blue),
        other: RadarChartSet(data: Array(repeating: 0.8, count: 9), caption: "", color: .red))
#else
    var defeated: RadarChartStats?
#endif
        init(defeated: RadarChartStats? = nil) {
            self.defeated = defeated
        }

        var body: some View {
            if let defeated = defeated {
                RadarChart(data: [defeated.player, defeated.other])
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 6).fill(Color.whitesmoke))
            }
        }
    }
    
    struct WaveClearRatio: View {
#if DEBUG
    var result: [PieChartModel] = [
        PieChartModel(value: 10, color: .blue, title: ""),
        PieChartModel(value: 30, color: .yellow, title: ""),
        PieChartModel(value: 40, color: .red, title: ""),
        ]
#else
        var result: [PieChartModel]
#endif

        init(result: [PieChartModel] = []) {
            self.result = result
        }

        var body: some View {
            PieChart(data: result)
                .frame(maxHeight: 160)
                .aspectRatio(16/9, contentMode: .fit)
                .padding(.top, 12)
                .padding(.bottom, 6)
                .background(RoundedRectangle(cornerRadius: 6).fill(Color.whitesmoke))
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
//        Dashboard.BossDefeatedRatio()
//            .previewLayout(.fixed(width: 400, height: 400))
        Dashboard.WaveClearRatio()
            .previewLayout(.fixed(width: 320, height: 180))
    }
}
