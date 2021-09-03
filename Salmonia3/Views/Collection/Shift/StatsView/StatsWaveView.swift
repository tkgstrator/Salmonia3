//
//  StatsWaveView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/05/15.
//

import Foundation
import SwiftUI

struct StatsWaveView: View {
    @EnvironmentObject var stats: CoopShiftStats

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 128)), count: 3), alignment: .center, spacing: nil, pinnedViews: [.sectionHeaders]) {
                Section(header: waveHeader, content: {
                    ForEach(stats.resultWave) { wave in
                        Image(waterLevel: wave.tide)
                            .overlay(
                                Text(EventType(rawValue: wave.event)!.eventType.localized)
                                    .splatfont2(.blackrussian, size: 20),
                                alignment: .center
                            )
                            .overlay(
                                Text(wave.goldenEggs.stringValue)
                                    .splatfont2(.blackrussian, size: 20)
                                    .offset(x: 0, y: 20)
                                ,
                                alignment: .center
                            )
                            .padding(.vertical, 8)
                            .visible(isVisible(eventType: wave.event, waterLevel: wave.tide))
                    }
                })
            }
        }
        .background(Color.seashell.edgesIgnoringSafeArea(.all))
        .splatfont2(size: 14)
    }
    
    var waveHeader: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 128)), count: 3), alignment: .center, spacing: nil, pinnedViews: [.sectionHeaders]) {
            ForEach(WaterLevel.allCases) { tide in
                Text(tide.waterLevel.localized)
                    .splatfont2(.blackrussian, size: 20)
            }
        }
    }
    
    private func isVisible(eventType: Int, waterLevel: Int) -> Bool {
        return !((eventType >= 1 && eventType <= 3) && waterLevel == 0) && !(eventType == 6 && waterLevel != 0)
    }
}

