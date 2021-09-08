//
//  CoopRecordView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/05/09.
//

import SwiftUI

struct CoopRecordView: View {
    
    @State var record: CoopRecord
    private var stageId: Int
    
    init(stageId: Int) {
        self.stageId = stageId
        self._record = State(initialValue: CoopRecord(stageId: stageId))
    }
    
    var body: some View {
        List {
            Section(header: Text(.HEADER_OVERVIEW).splatfont2(.safetyorange, size: 14)) {
                RecordColumn(title: .RESULT_JOB_NUM, value: record.jobNum)
                RecordColumn(title: .RESULT_MAX_GRADE, value: record.maxGrade)
                RecordColumn(title: .RESULT_MAX_GRADE_NUM, value: record.counterStepNum)
                RecordColumn(title: .RESULT_MIN_MAX_GRADE, value: record.minimumStepNum)
                RecordColumn(title: .RESULT_MAX_GOLDEN_EGGS, value: record.maxGoldenEggs.all)
                RecordColumn(title: .RESULT_MAX_GOLDEN_EGGS_NONIGHT, value: record.maxGoldenEggs.nonight)
            }
            ForEach(WaterLevel.allCases, id:\.self) { tide in
                Section(header: Text(tide.localizedName).splatfont2(.safetyorange, size: 14)) {
                    ForEach(EventType.allCases, id:\.self) { event in
                        if let goldenEggs = record.goldenEggs[tide.rawValue][event.rawValue]?.goldenEggs {
                            RecordColumn(title: event.localizedName, value: goldenEggs)
                        }
                    }
                    
                }
            }
        }
        .navigationTitle(StageType.init(rawValue: stageId)!.localizedName)
    }
}

fileprivate struct RecordColumn: View {
    var title: String
    var value: String
    
    init(title: LocalizableStrings.Key, value: Optional<Any>)
    {
        self.title = title.rawValue.localized
        self.value = value.stringValue
    }
    
    init(title: String, value: Optional<Any>)
    {
        self.title = title.localized
        self.value = value.stringValue
    }
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
        .font(.custom("Splatfont2", size: 16))
    }
}
