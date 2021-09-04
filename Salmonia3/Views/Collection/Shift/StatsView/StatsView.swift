//
//  StatsView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/05/15.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var stats: CoopShiftStats
    var startTime: Int

    var body: some View {
        List {
            Section(header: Text(.HEADER_OVERVIEW).splatfont2(.orange, size: 14)) {
                CoopShift(shift: try! RealmManager.shared.getShiftSchedule(startTime: startTime))
                StatsColumn(title: .RESULT_JOB_NUM, value: stats.overview.jobNum)
                StatsColumn(title: .RESULT_CREW_AVG_NUM, value: stats.overview.crewAvg)
                StatsColumn(title: .RESULT_CLEAR_RATIO, value: stats.overview.clearRatio)
                StatsColumn(title: .RESULT_RATIO_POWER_EGGS, value: stats.overview.powerEggRatio)
                StatsColumn(title: .RESULT_RATIO_GOLDEN_EGGS, value: stats.overview.goldenEggRatio)
            }
            Section(header: Text(.HEADER_STATS_MAX).splatfont2(.orange, size: 14)) {
                StatsColumn(title: .RESULT_POWER_EGGS, value: stats.resultMax.powerEggs)
                StatsColumn(title: .RESULT_GOLDEN_EGGS, value: stats.resultMax.goldenEggs)
                StatsColumn(title: .RESULT_TEAM_POWER_EGGS, value: stats.resultMax.teamPowerEggs)
                StatsColumn(title: .RESULT_TEAM_GOLDEN_EGGS, value: stats.resultMax.teamGoldenEggs)
                StatsColumn(title: .RESULT_DEFEATED, value: stats.resultMax.bossDefeated)
                StatsColumn(title: .RESULT_HELP_COUNT, value: stats.resultMax.helpCount)
                StatsColumn(title: .RESULT_DEAD_COUNT, value: stats.resultMax.deadCount)
            }
            Section(header: Text(.HEADER_STATS_AVG).splatfont2(.orange, size: 14)) {
                StatsColumn(title: .RESULT_POWER_EGGS, value: stats.resultAvg.powerEggs)
                StatsColumn(title: .RESULT_GOLDEN_EGGS, value: stats.resultAvg.goldenEggs)
                StatsColumn(title: .RESULT_TEAM_POWER_EGGS, value: stats.resultAvg.teamPowerEggs)
                StatsColumn(title: .RESULT_TEAM_GOLDEN_EGGS, value: stats.resultAvg.teamGoldenEggs)
                StatsColumn(title: .RESULT_DEFEATED, value: stats.resultAvg.bossDefeated)
                StatsColumn(title: .RESULT_HELP_COUNT, value: stats.resultAvg.helpCount)
                StatsColumn(title: .RESULT_DEAD_COUNT, value: stats.resultAvg.deadCount)
            }
            ForEach(WaterLevel.allCases, id:\.rawValue) { tide in
                Section(header: Text(tide.waterLevel.localized).splatfont2(.orange, size: 14)) {
                    ForEach(EventType.allCases, id:\.rawValue) { event in
                        if let goldenEggs = stats.records.goldenEggs[tide.rawValue][event.rawValue]?.goldenEggs {
                            StatsColumn(title: event.eventType, value: goldenEggs)
                        }
                    }
                }
            }
        }
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
