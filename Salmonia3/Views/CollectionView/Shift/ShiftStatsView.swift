//
//  ShiftStatsView.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/26.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet2

struct ShiftStatsView: View {
    @StateObject var stats: UserShiftStats
//    @StateObject var rank: RankShiftStats
    let schedule: RealmCoopShift

    init(schedule: RealmCoopShift, nsaid: String?) {
        self.schedule = schedule
//        self._rank = StateObject(wrappedValue: RankShiftStats(startTime: schedule.startTime, nsaid: nsaid))
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
                switch schedule.shiftType {
                case .oneRandom, .allRandom:
                    NavigationLink(destination: WeaponCollectionView(shift: schedule, nsaid: stats.nsaid), label: {
                        StatsWeapon(weaponProbs: stats.weaponProbs)
                    })
                default:
                    StatsWeapon(weaponProbs: stats.weaponProbs)
                }
                StatsSpecial(specialProbs: stats.specialProbs)
            })
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), content: {
                ForEach(stats.teamIkuraNum) { ikuraNum in
                    StatsCardHalf(score: ikuraNum.score, caption: ikuraNum.caption)
                }
                ForEach(stats.teamGoldenIkuraNum) { goldenIkuraNum in
//                    NavigationLink(destination: RankingCollection(rank: rank), label: {
                        StatsCardHalf(score: goldenIkuraNum.score, caption: goldenIkuraNum.caption)
                            .overlay(Text("タップで詳細を表示").underline().padding(.bottom, 4).font(systemName: .Splatfont2, size: 14), alignment: .bottom)
//                    })
                    .buttonStyle(.plain)
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
