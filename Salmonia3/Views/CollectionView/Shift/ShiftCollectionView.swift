//
//  ShiftCollectionView.swift
//  Salmonia3
//
//  Created by devonly on 2021/11/24.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftyUI
import RealmSwift
import SplatNet2
import SalmonStats

final class ShiftService: ObservableObject {
    @Published var shiftDisplayMode: ShiftDisplayMode = .current
    @Published var nsaid: String
    @ObservedResults(
        RealmCoopShift.self,
        filter: NSPredicate("startTime", lessThan: Int(Date().timeIntervalSince1970)),
        sortDescriptor: SortDescriptor(keyPath: "startTime", ascending: false)
    )
    var schedules
    
    init() {
        let session: SalmonStats = SalmonStats()
        self.nsaid = session.account.credential.nsaid
    }
}

struct ShiftCollectionView: View {
    @StateObject var service: ShiftService = ShiftService()
    @State var isPresented: Bool = false

    var body: some View {
        NavigationView(content: {
            ScrollViewReader(content: { scrollProxy in
                List(content: {
                    if let nsaid = service.nsaid {
                        ForEach(service.schedules) { schedule in
                            NavigationLinker(destination: ShiftStatsView(schedule: schedule, nsaid: nsaid), label: {
                                ShiftView(shift: schedule)
                            })
                            .id(schedule.startTime)
                            .disabled(schedule.startTime >= Int(Date().timeIntervalSince1970))
                        }
                    }
                })
            })
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("シフトスケジュール")
            .withAdmobBanner()
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        isPresented.toggle()
                    }, label: {
                        Image(systemName: .Line3HorizontalDecreaseCircle)
                    })
                })
            })
            .halfsheet(isPresented: $isPresented, onDismiss: {
                withAnimation(.easeInOut(duration: 1.0)) {
                    switch service.shiftDisplayMode {
                    case .current:
                        service.$schedules.filter = NSPredicate("startTime", lessThan: Int(Date().timeIntervalSince1970))
                        service.objectWillChange.send()
                    case .all:
                        service.$schedules.filter = nil
                        service.objectWillChange.send()
                    case .played:
                        service.$schedules.filter = NSPredicate("startTime", lessThan: Int(Date().timeIntervalSince1970))
                        service.objectWillChange.send()
                    }
                }
            }, content: {
                ShiftFilterButton()
                    .environmentObject(service)
            })
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

//struct ShiftCollectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShiftCollectionView()
//    }
//}
