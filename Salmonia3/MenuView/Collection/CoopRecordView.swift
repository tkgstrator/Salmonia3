//
//  CoopRecordView.swift
//  Salmonia3
//
//  Created by devonly on 2021/05/09.
//

import SwiftUI

struct CoopRecordView: View {
    var stageId: Int
    @StateObject var record: CoopRecord

    var body: some View {
        List {
            Section(header: Text("HEADER_STATS_OVERVIEW")) {
                RecordColumn(title: .jobnum, value: record.jobNum)
            }
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

fileprivate enum RecordType: String, CaseIterable {
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


struct CoopRecordView_Previews: PreviewProvider {
    static var previews: some View {
        CoopRecordView(stageId: 5000, record: CoopRecord(stageId: 5000))
    }
}
