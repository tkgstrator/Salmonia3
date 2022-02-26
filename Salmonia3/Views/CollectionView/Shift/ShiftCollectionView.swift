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
    @EnvironmentObject var service: AppService
    @ObservedResults(RealmCoopShift.self, sortDescriptor: SortDescriptor(keyPath: "startTime", ascending: false)) var schedules
    @State var isPresented: Bool = false
    
    var nsaid: String? {
        service.account?.credential.nsaid
    }
    
    func filterSchedules() {
        switch service.shiftDisplayMode {
        case .all:
            $schedules.filter = nil
        case .played:
            $schedules.filter = NSPredicate("startTime", valuesIn: service.playedShiftScheduleId)
        case .current:
            $schedules.filter = NSPredicate("startTime", lessThan: Int(Date().timeIntervalSince1970))
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
                .onAppear(perform: {
                    filterSchedules()
                })
                .halfsheet(isPresented: $isPresented, onDismiss: {
                    filterSchedules()
                }, content: {
                    ShiftFilterButton()
                        .environmentObject(service)
                })
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
