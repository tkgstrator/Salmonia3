//
//  CoopRecordView.swift
//  Salmonia3
//
//  Created by devonly on 2021/05/09.
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
            Section(header: Text(.HEADER_OVERVIEW).splatfont2(.orange, size: 14)) {
                RecordColumn(title: .RESULT_JOB_NUM, value: record.jobNum)
                RecordColumn(title: .RESULT_MAX_GRADE, value: record.maxGrade)
                RecordColumn(title: .RESULT_MAX_GRADE_NUM, value: record.counterStepNum)
                RecordColumn(title: .RESULT_MIN_MAX_GRADE, value: record.minimumStepNum)
            }
            ForEach(WaterLevel.allCases, id:\.self) { tide in
                Section(header: Text(tide.waterLevel.localized).splatfont2(.orange, size: 14)) {
                    ForEach(EventType.allCases, id:\.self) { event in
                        if let goldenEggs = record.goldenEggs[tide.rawValue][event.rawValue]?.goldenEggs {
                            RecordColumn(title: event.eventType, value: goldenEggs)
                        }
                    }
                    
                }
            }
        }
        .navigationTitle(StageType.init(rawValue: stageId)!.name.localized)
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
