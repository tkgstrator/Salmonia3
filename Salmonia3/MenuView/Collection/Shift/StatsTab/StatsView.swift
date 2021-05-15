//
//  StatsView.swift
//  Salmonia3
//
//  Created by devonly on 2021/05/15.
//

import SwiftUI

struct StatsView: View {
    
    @Binding var startTime: Int
    @State var result: CoopShiftStats?

    private func getShiftStats() {
        result = CoopShiftStats(startTime: startTime)
    }
    
    var body: some View {
        List {
            Section(header: Text("HEADER_STATS_OVERVIEW").splatfont2(.orange, size: 14)) {
                CoopShift(shift: try! RealmManager.getShiftSchedule(startTime: startTime))
                StatsColumn(title: .jobnum, value: result?.overview?.jobNum)
                StatsColumn(title: .clearRatio, value: result?.overview?.clearRatio)
                StatsColumn(title: .ratioPowerEggs, value: result?.overview?.powerEggRatio)
                StatsColumn(title: .ratioGoldenEggs, value: result?.overview?.goldenEggRatio)
            }
            Section(header: Text("HEADER_STATS_MAX").splatfont2(.orange, size: 14)) {
                StatsColumn(title: .powerEggs, value: result?.resultMax?.powerEggs)
                StatsColumn(title: .goldenEggs, value: result?.resultMax?.goldenEggs)
                StatsColumn(title: .teamPowerEggs, value: result?.resultMax?.teamPowerEggs)
                StatsColumn(title: .teamGoldenEggs, value: result?.resultMax?.teamGoldenEggs)
                StatsColumn(title: .defeated, value: result?.resultMax?.bossDefeated)
                StatsColumn(title: .helpCount, value: result?.resultMax?.helpCount)
                StatsColumn(title: .deadCount, value: result?.resultMax?.deadCount)
            }
            Section(header: Text("HEADER_STATS_AVG").splatfont2(.orange, size: 14)) {
                StatsColumn(title: .powerEggs, value: result?.resultAvg?.powerEggs)
                StatsColumn(title: .goldenEggs, value: result?.resultAvg?.goldenEggs)
                StatsColumn(title: .teamPowerEggs, value: result?.resultAvg?.teamPowerEggs)
                StatsColumn(title: .teamGoldenEggs, value: result?.resultAvg?.teamGoldenEggs)
                StatsColumn(title: .defeated, value: result?.resultAvg?.bossDefeated)
                StatsColumn(title: .helpCount, value: result?.resultAvg?.helpCount)
                StatsColumn(title: .deadCount, value: result?.resultAvg?.deadCount)
            }
        }
        .onAppear(perform: getShiftStats)
        .navigationTitle("TITLE_SHIFT_STATS")
    }
}

fileprivate struct StatsColumn: View {
    
    var title: String
    var value: String
    
    init(title: ShiftStatsType, value: Optional<Any>)
    {
        self.title = title.rawValue
        self.value = value.stringValue
    }
    
    var body: some View {
        HStack {
            Text(title.localized)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
        .font(.custom("Splatfont2", size: 16))
    }
}

fileprivate enum ShiftStatsType: String, CaseIterable {
    case jobnum             = "JOB_NUM"
    case clearRatio         = "CLEAR_RATIO"
    case salmonPower        = "SALMON_RATE"
    case clearWave          = "CLEAR_WAVE"
    case crewGrade          = "CREW_GRADE"
    case gradePoint         = "GRADE_POINT"
    case teamPowerEggs      = "TEAM_POWER_EGGS"
    case teamGoldenEggs     = "TEAM_GOLDEN_EGGS"
    case powerEggs          = "POWER_EGGS"
    case goldenEggs         = "GOLDEN_EGGS"
    case defeated           = "BOSS_DEFEATED"
    case helpCount          = "HELP_COUNT"
    case deadCount          = "DEAD_COUNT"
    case ratioPowerEggs     = "RATIO_POWER_EGGS"
    case ratioGoldenEggs    = "RATIO_GOLDEN_EGGS"
}
