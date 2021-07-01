//
//  StatsWaveView.swift
//  Salmonia3
//
//  Created by devonly on 2021/05/15.
//

import Foundation
import SwiftUI

struct StatsWaveView: View {
    @ObservedObject var stats: CoopShiftStats
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 200)), count: 3), alignment: .center, spacing: nil, pinnedViews: []) {
                ForEach(stats.resultWave.indices) { index in
                    CircleWaveView(tide: 80)
                        .overlay(Text(stats.resultWave[index].goldenEggs.stringValue))
                }
            }
        }
    }
}
//
//struct StatsWaveView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatsWaveView()
//    }
//}
