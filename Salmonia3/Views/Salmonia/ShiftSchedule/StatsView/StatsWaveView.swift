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
        ScrollView(.vertical, showsIndicators: false, content: {
            LazyVStack(alignment: .center, spacing: nil, pinnedViews: [.sectionHeaders], content: {
                Section(header: waveHeader, content: {
                    ForEach(EventType.allCases) { eventType in
                        switch eventType {
                        case .noevent:
                            Text(.NO_NIGHT_WAVE)
                                .splatfont2(.blackrussian, size: 20)
                        case .rush:
                            Text(.NO_NIGHT_WAVE)
                                .splatfont2(.blackrussian, size: 20)
                        default:
                            EmptyView()
                        }
                        LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 128)), count: 3), alignment: .center, spacing: nil, pinnedViews: [], content: {
                            ForEach(WaterLevel.allCases) { waterLevel in
                                Image(waterLevel: waterLevel.rawValue)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.horizontal, 4)
                                    .overlay(
                                        Text(eventType.localizedName)
                                            .splatfont2(.blackrussian, size: 20),
                                        alignment: .center
                                    )
                                    .overlay(
                                        Text(stats.resultWave.filter({ $0.waterLevel == waterLevel && $0.eventType == eventType }).first!.goldenIkuraAvg.stringValue)
                                            .splatfont2(.blackrussian, size: 20)
                                            .offset(x: 0, y: 20),
                                        alignment: .center
                                    )
                                    .visible(isVisible(eventType: eventType, waterLevel: waterLevel))
                            }
                        })
                        Image(ResultIcon.dot)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                })
            })
        })
        .onAppear {
            print(stats.resultWave.map({ $0.goldenIkuraAvg }))
        }
        .background(Color.seashell.edgesIgnoringSafeArea(.all))
        .splatfont2(size: 14)
    }
    
    var waveHeader: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 128)), count: 3), alignment: .center, spacing: nil, pinnedViews: [.sectionHeaders]) {
            ForEach(WaterLevel.allCases) { tide in
                Text(tide.localizedName)
                    .splatfont2(.blackrussian, size: 20)
            }
        }
    }
    
    /// 存在するイベントと潮位の組み合わせかを返す
    private func isVisible(eventType: EventType, waterLevel: WaterLevel) -> Bool {
        return !((eventType.rawValue >= 1 && eventType.rawValue <= 3) && waterLevel.rawValue == 0) && !(eventType.rawValue == 6 && waterLevel.rawValue != 0)
    }
}

