//
//  CoopRecordView.swift
//  Salmonia3
//
//  Created by devonly on 2021/05/09.
//

import SwiftUI

struct CoopRecordView: View {
    
    @State var record: StageRecord = StageRecord()
    @State private var eventTypes: [String] = [
        "water-levels", "rush", "goldie-seeking",
        "griller", "the-mothership", "fog", "cohock-charge"
    ]
    @State private var waterLevels: [String] = ["low", "normal", "high"]
    var stageId: Int

    var body: some View {
        List {
            Section(header: Text(.HEADER_OVERVIEW).splatfont2(.orange, size: 14)) {
                RecordColumn(title: .RESULT_JOB_NUM, value: record.jobNum)
                RecordColumn(title: .RESULT_MAX_GRADE, value: record.maxGrade)
            }
            ForEach(Range(0...2)) { tide in
                Section(header: Text(waterLevels[tide].localized).splatfont2(.orange, size: 14)) {
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
