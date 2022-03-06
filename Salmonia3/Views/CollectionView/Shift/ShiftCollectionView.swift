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
import SplatNet2

struct ShiftCollectionView: View {
    @EnvironmentObject var service: AppService
    @ObservedResults(RealmCoopShift.self, sortDescriptor: SortDescriptor(keyPath: "startTime", ascending: false)) var schedules
    @State var isPresented: Bool = false
    
    var nsaid: String? {
        service.account?.credential.nsaid
    }
    
    func update(mode: ShiftDisplayMode) {
        switch mode {
        case .all:
            $schedules.filter = nil
        case .current:
            $schedules.filter = NSPredicate("startTime", lessThan: Int(Date().timeIntervalSince1970))
        case .played:
            $schedules.filter = NSPredicate("startTime", valuesIn: service.playedShiftScheduleId)
        }
    }
    
    var body: some View {
        NavigationView(content: {
            List(content: {
                ForEach(schedules) { schedule in
                    NavigationLinker(destination: ShiftStatsView(schedule: schedule, nsaid: nsaid), label: {
                        ShiftView(shift: schedule)
                    })
                        .disabled(schedule.startTime >= Int(Date().timeIntervalSince1970))
                }
            })
                .listStyle(.plain)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("シフトスケジュール")
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        Button(action: {
                            isPresented.toggle()
                        }, label: {
                            Image(systemName: .Line3HorizontalDecreaseCircle)
                        })
                    })
                })
            //                .onAppear(perform: {
            //                    update(mode: service.shiftDisplayMode)
            //                })
        })
            .halfsheet(isPresented: $isPresented, content: {
                ShiftFilterButton()
                    .environmentObject(service)
            })
            .navigationViewStyle(.split)
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
