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
            Section(header: Text(.HEADER_OVERVIEW).splatfont2(.orange, size: 14)) {
                CoopShift(shift: try! RealmManager.getShiftSchedule(startTime: startTime))
                StatsColumn(title: .RESULT_JOB_NUM, value: result?.overview?.jobNum)
                StatsColumn(title: .RESULT_CLEAR_RATIO, value: result?.overview?.clearRatio)
                StatsColumn(title: .RESULT_POWER_EGGS, value: result?.overview?.powerEggRatio)
                StatsColumn(title: .RESULT_GOLDEN_EGGS, value: result?.overview?.goldenEggRatio)
            }
            Section(header: Text(.HEADER_STATS_MAX).splatfont2(.orange, size: 14)) {
                StatsColumn(title: .RESULT_POWER_EGGS, value: result?.resultMax?.powerEggs)
                StatsColumn(title: .RESULT_GOLDEN_EGGS, value: result?.resultMax?.goldenEggs)
                StatsColumn(title: .RESULT_TEAM_POWER_EGGS, value: result?.resultMax?.teamPowerEggs)
                StatsColumn(title: .RESULT_TEAM_GOLDEN_EGGS, value: result?.resultMax?.teamGoldenEggs)
                StatsColumn(title: .RESULT_DEFEATED, value: result?.resultMax?.bossDefeated)
                StatsColumn(title: .RESULT_HELP_COUNT, value: result?.resultMax?.helpCount)
                StatsColumn(title: .RESULT_DEAD_COUNT, value: result?.resultMax?.deadCount)
            }
            Section(header: Text(.HEADER_STATS_AVG).splatfont2(.orange, size: 14)) {
                StatsColumn(title: .RESULT_POWER_EGGS, value: result?.resultAvg?.powerEggs)
                StatsColumn(title: .RESULT_GOLDEN_EGGS, value: result?.resultAvg?.goldenEggs)
                StatsColumn(title: .RESULT_TEAM_POWER_EGGS, value: result?.resultAvg?.teamPowerEggs)
                StatsColumn(title: .RESULT_TEAM_GOLDEN_EGGS, value: result?.resultAvg?.teamGoldenEggs)
                StatsColumn(title: .RESULT_DEFEATED, value: result?.resultAvg?.bossDefeated)
                StatsColumn(title: .RESULT_HELP_COUNT, value: result?.resultAvg?.helpCount)
                StatsColumn(title: .RESULT_DEAD_COUNT, value: result?.resultAvg?.deadCount)
            }
            ForEach(WaterLevel.allCases, id:\.rawValue) { tide in
                Section(header: Text(tide.waterLevel.localized).splatfont2(.orange, size: 14)) {
                    ForEach(EventType.allCases, id:\.rawValue) { event in
                        if let goldenEggs = result?.records.goldenEggs[tide.rawValue][event.rawValue]?.goldenEggs {
                            StatsColumn(title: event.eventType, value: goldenEggs)
                        }
                    }
                }
            }
        }
        .onAppear(perform: getShiftStats)
    }
}

fileprivate struct StatsColumn: View {
    var title: String
    var value: String
    
    init(title: LocalizableStrings.Key, value: Optional<Any>)
    {
        self.title = title.rawValue
        self.value = value.stringValue
    }
    
    init(title: String, value: Optional<Any>)
    {
        self.title = title.localized
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
