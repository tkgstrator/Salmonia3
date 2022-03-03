//
//  ShiftStatsView.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/26.
//

import SwiftUI
import SplatNet2

struct ShiftStatsView: View {
    @StateObject var stats: UserShiftStats
    let schedule: RealmCoopShift
    
    init(schedule: RealmCoopShift, nsaid: String?) {
        self.schedule = schedule
        self._stats = StateObject(wrappedValue: UserShiftStats(startTime: schedule.startTime, nsaid: nsaid))
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            ShiftView(shift: schedule)
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), content: {
                ForEach(stats.clearRatio) { clearWave in
                    StatsCardHalf(score: clearWave.score, caption: clearWave.caption)
                }
            })
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 1), content: {
                StatsWeapon(weaponProbs: stats.weaponProbs)
                StatsSpecial(specialProbs: stats.specialProbs)
            })
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), content: {
                ForEach(stats.teamIkuraNum) { ikuraNum in
                    StatsCardHalf(score: ikuraNum.score, caption: ikuraNum.caption)
                }
                ForEach(stats.teamGoldenIkuraNum) { goldenIkuraNum in
                    StatsCardHalf(score: goldenIkuraNum.score, caption: goldenIkuraNum.caption, rank: goldenIkuraNum.rank, total: goldenIkuraNum.total)
                }
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
                ForEach(stats.defeatedCount) { defeatedCount in
                    StatsCard(stats: defeatedCount)
                }
            })
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), content: {
                ForEach(stats.defeatedIdCount) { defeatedCount in
                    StatsCardSmall(stats: defeatedCount)
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
