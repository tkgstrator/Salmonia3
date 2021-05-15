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
        TabView {
            StatsView(startTime: $startTime)
                .tag(0)
            StatsWaveView()
                .tag(1)
            StatsWeaponView()
                .tag(2)
        }
        .edgesIgnoringSafeArea(.bottom)
        .tabViewStyle(PageTabViewStyle())
    }
}
