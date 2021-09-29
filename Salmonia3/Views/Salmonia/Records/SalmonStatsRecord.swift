//
//  SalmonStatsRecord.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/29.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftUIX
import RealmSwift

struct SalmonStatsRecord: View {
    @ObservedResults(RealmStatsRecord.self, filter: NSPredicate(format: "eventType=nil AND waterLevel=nil AND recordType=0 AND recordTypeEgg=1"), sortDescriptor: SortDescriptor(keyPath: "goldenEggs", ascending: false)) var records
    
    var body: some View {
        List {
            ForEach(records) { record in
                WaveOverview()
                    .environment(\.wave, CoopWave(from: record))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(.TITLE_WAVE_COLLECTION)
    }
}

struct SalmonStatsRecord_Previews: PreviewProvider {
    static var previews: some View {
        SalmonStatsRecord()
    }
}
