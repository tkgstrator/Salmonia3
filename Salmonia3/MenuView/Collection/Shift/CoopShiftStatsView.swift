//
//  CoopShiftStatsView.swift
//  Salmonia3
//
//  Created by Devonly on 3/23/21.
//

import SwiftUI
import RealmSwift

struct CoopShiftStatsView: View {
    @State var startTime: Int
    @State private var seletion: Int = 0
    
    var body: some View {
        TabView(selection: $seletion) {
            StatsView(startTime: $startTime)
                .tag(0)
            StatsWaveView(stats: CoopShiftStats(startTime: startTime))
                .tag(1)
            StatsWeaponView(stats: CoopShiftStats(startTime: startTime))
                .tag(2)
        }
        .navigationTitle("TITLE_SHIFT_STATS")
        .edgesIgnoringSafeArea(.bottom)
        .tabViewStyle(PageTabViewStyle())
    }
}
