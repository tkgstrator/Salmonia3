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
    @State var isExpanded: [Bool] = Array(repeating: false, count: 2)
    
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
            .navigationViewStyle(SplitNavigationViewStyle())
    }
}

struct ShiftCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        ShiftCollectionView()
    }
}
