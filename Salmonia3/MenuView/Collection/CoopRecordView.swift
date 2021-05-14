//
//  CoopRecordView.swift
//  Salmonia3
//
//  Created by devonly on 2021/05/09.
//

import SwiftUI

struct CoopRecordView: View {
//    #warning("EnvironmentObjectに切り替えてもいいかも")
    @State var record: StageRecord = StageRecord()
    var stageId: Int
    @State private var eventTypes: [RecordType] = [.noevent, .rush, .goldie, .griller, .mothership, .fog, .cohock]
    @State private var waterLevels: [String] = ["low", "normal", "high"]
    var body: some View {
        List {
            Section(header: Text("HEADER_STATS_OVERVIEW")) {
                RecordColumn(title: .jobnum, value: record.jobNum)
                RecordColumn(title: .maxGrade, value: record.maxGrade)
            }
            ForEach(Range(0...2)) { tide in
                Section(header: Text(waterLevels[tide].localized)) {
                    ForEach(Range(0...6)) { event in
                        if record.goldenEggs[tide][event] != nil {
                            RecordColumn(title: eventTypes[event], value: record.goldenEggs[tide][event]?.goldenEggs)
                        }
                    }
                }
            }
        }
        .onAppear {
            record = StageRecord(stageId: stageId)
        }
        .navigationTitle(StageType.init(rawValue: stageId)!.name.localized)
    }
}

fileprivate struct RecordColumn: View {
    var title: String
    var value: String
    
    init(title: RecordType, value: Optional<Any>)
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
        .font(.custom("Splatfont2", size: 14))
    }
}

internal enum RecordType: String, CaseIterable {
    case jobnum             = "JOB_NUM"
    case maxGrade           = "MAX_GRADE"
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
    case noevent            = "water-levels"
    case rush               = "rush"
    case goldie             = "goldie-seeking"
    case griller            = "griller"
    case fog                = "fog"
    case mothership         = "the-mothership"
    case cohock             = "cohock-charge"
}
