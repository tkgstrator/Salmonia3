//
//  ShiftCollectionView.swift
//  Salmonia3
//
//  Created by devonly on 2021/11/24.
//  
//

import SwiftUI
import RealmSwift

struct ShiftCollectionView: View {
    @ObservedResults(RealmCoopShift.self, sortDescriptor: SortDescriptor(keyPath: "startTime", ascending: false)) var schedules
    @ObservedResults(RealmCoopResult.self) var results
    
    var body: some View {
        NavigationView(content: {
            List(content: {
                ForEach(schedules) { schedule in
                    if results.map({ $0.startTime }).contains(schedule.startTime) {
                        NavigationLinker(destination: FireStatsView(startTime: schedule.startTime), label: {
                            Text(schedule.startTime)
                        })
                    }
                }
            })
        })
    }
}

struct ShiftCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        ShiftCollectionView()
    }
}
