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

final class ShiftService: ObservableObject {
    @Published var shiftDisplayMode: ShiftDisplayMode = .current
    @Published var nsaid: String?
    @ObservedResults(
        RealmCoopShift.self,
        filter: NSPredicate("startTime", lessThan: Int(Date().timeIntervalSince1970)),
        sortDescriptor: SortDescriptor(keyPath: "startTime", ascending: false)
    )
    var schedules
    
    init(nsaid: String?) {
        self.nsaid = nsaid
    }
}

struct ShiftCollectionView: View {
    @StateObject var service: ShiftService
    @State var isPresented: Bool = false
    
    init(nsaid: String?) {
        self._service = StateObject(wrappedValue: ShiftService(nsaid: nsaid))
    }
    
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
