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
    @State private var stats: CoopShiftStats?
    
    var body: some View {
        #if DEBUG
        TabView(selection: $seletion) {
            StatsView(startTime: $startTime)
                .tag(0)
//            StatsWaveView(stats: CoopShiftStats(startTime: startTime))
//                .tag(1)
//            StatsWeaponView(stats: CoopShiftStats(startTime: startTime))
//                .tag(2)
        }
//        .onAppear { }
        .navigationTitle(.TITLE_SHIFT_STATS)
        .edgesIgnoringSafeArea(.bottom)
        .tabViewStyle(PageTabViewStyle())
        #else
        StatsView(startTime: $startTime)
        .navigationTitle(.TITLE_SHIFT_STATS)
        .edgesIgnoringSafeArea(.bottom)
        .tabViewStyle(PageTabViewStyle())
        #endif
    }
}
