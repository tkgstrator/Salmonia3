//
//  CoopShiftStatsView.swift
//  Salmonia3
//
//  Created by Devonly on 3/23/21.
//

import SwiftUI
import RealmSwift

struct CoopShiftStatsView: View {
    
    var result: ShiftStats
    var shift: RealmCoopShift
    
    init(startTime: Int) {
        self.shift = try! RealmManager.getShiftSchedule(startTime: startTime)
        self.result = ShiftStats(startTime: startTime)
        dump(result)
    }

    var body: some View {
        List {
            Section(header: Text("HEADER_STATS_OVERVIEW")) {
                CoopShift(shift: shift)
                StatsColumn(title: .jobnum, value: result.overview.jobNum)
                StatsColumn(title: .clearRatio, value: result.overview.clearRatio)
            }
            Section(header: Text("HEADER_STATS_MAX")) {
                StatsColumn(title: .powerEggs, value: result.resultMax.powerEggs)
                StatsColumn(title: .goldenEggs, value: result.resultMax.goldenEggs)
                StatsColumn(title: .teamPowerEggs, value: result.resultMax.teamPowerEggs)
                StatsColumn(title: .teamGoldenEggs, value: result.resultMax.teamGoldenEggs)
                StatsColumn(title: .defeated, value: result.resultMax.bossDefeated)
                StatsColumn(title: .defeated, value: result.resultMax.deadCount)
                StatsColumn(title: .helpCount, value: result.resultMax.helpCount)
            }
            Section(header: Text("HEADER_STATS_AVG")) {
                StatsColumn(title: .powerEggs, value: result.resultMax.powerEggs)
                StatsColumn(title: .goldenEggs, value: result.resultMax.goldenEggs)
                StatsColumn(title: .teamPowerEggs, value: result.resultMax.teamPowerEggs)
                StatsColumn(title: .teamGoldenEggs, value: result.resultMax.teamGoldenEggs)
                StatsColumn(title: .defeated, value: result.resultMax.bossDefeated)
                StatsColumn(title: .defeated, value: result.resultMax.deadCount)
                StatsColumn(title: .helpCount, value: result.resultMax.helpCount)
            }
        }
        .onAppear() {
            dump(result)
        }
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
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
        .font(.custom("Splatfont2", size: 14))
    }
}

fileprivate enum ShiftStatsType: String, CaseIterable {
    case jobnum         = "JOB_NUM"
    case clearRatio     = "CLEAR_RATIO"
    case salmonPower    = "SALMON_RATE"
    case clearWave      = "CLEAR_WAVE"
    case crewGrade      = "CREW_GRADE"
    case gradePoint     = "GRADE_POINT"
    case teamPowerEggs  = "TEAM_POWER_EGGS"
    case teamGoldenEggs = "TEAM_GOLDEN_EGGS"
    case powerEggs      = "POWER_EGGS"
    case goldenEggs     = "GOLDEN_EGGS"
    case defeated       = "BOSS_DEFEATED"
    case helpCount      = "HELP_COUNT"
    case deadCount      = "DEAD_COUNT"
}


fileprivate extension Optional {
    var stringValue: String {
        switch self {
        case is Int:
            guard let _ = self else { return "-" }
            return String(self as! Int)
        case is Double:
            guard let _ = self else { return "-" }
            return String(Double(Int(self as! Double * 100)) / 100)
        default:
            return "-"
        }
    }
}
