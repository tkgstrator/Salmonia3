//
//  ShiftCollectionView.swift
//  Salmonia3
//
//  Created by devonly on 2021/11/24.
//  
//

import SwiftUI
import SwiftyUI
import RealmSwift

struct ShiftCollectionView: View {
    @ObservedResults(RealmCoopShift.self, sortDescriptor: SortDescriptor(keyPath: "startTime", ascending: false)) var schedules
    @ObservedResults(RealmCoopResult.self) var results
    
    var body: some View {
        NavigationView(content: {
            List(content: {
                ForEach(schedules) { schedule in
                    NavigationLinker(destination: SalmonStatPlusView(startTime: schedule.startTime), label: {
                        ShiftView(shift: schedule)
                    })
                        .disabled(schedule.startTime >= Int(Date().timeIntervalSince1970))
                }
            })
                .listStyle(.plain)
                .navigationTitle("TITLE.SHIFTSCHEDULE")
        })
            .onAppear(perform: {
                $schedules.filter = NSPredicate(format: "startTime in %@", argumentArray: [results.playedScheduleList])
            })
            .navigationViewStyle(SplitNavigationViewStyle())
    }
}

private extension RealmSwift.Results where Element == RealmCoopResult {
    /// 遊んだシフトIDの配列
    var playedScheduleList: [Int] {
        Array(Set(self.map({ $0.startTime }))).sorted(by: { $0 > $1 })
    }
}

struct ShiftCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        ShiftCollectionView()
    }
}
