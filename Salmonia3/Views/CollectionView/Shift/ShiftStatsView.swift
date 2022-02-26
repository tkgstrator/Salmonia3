//
//  ShiftStatsView.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/26.
//

import SwiftUI
import SplatNet2

struct ShiftStatsView: View {
    @StateObject var stats: StatsModel
    let schedule: RealmCoopShift
    
    init(schedule: RealmCoopShift, nsaid: String?) {
        self.schedule = schedule
        self._stats = StateObject(wrappedValue: StatsModel(startTime: schedule.startTime, nsaid: nsaid))
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            ShiftView(shift: schedule)
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), content: {
                ForEach(stats.ikuraNum) { ikuraNum in
                    StatsCard(stats: ikuraNum)
                }
                ForEach(stats.goldenIkuraNum) { goldenIkuraNum in
                    StatsCard(stats: goldenIkuraNum)
                }
                ForEach(stats.deadCount) { deadCount in
                    StatsCard(stats: deadCount)
                }
                ForEach(stats.helpCount) { helpCount in
                    StatsCard(stats: helpCount)
                }
            })
        })
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("シフト統計")
    }
}

//struct ShiftStatsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShiftStatsView()
//    }
//}
