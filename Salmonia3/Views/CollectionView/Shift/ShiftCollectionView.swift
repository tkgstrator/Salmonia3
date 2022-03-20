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
    @SceneStorage("sceneLoad") private var sceneLoad = false
    @AppStorage("appLoad") private var appLoad = false
    @EnvironmentObject var service: AppService
    @State var isPresented: Bool = false
    
    var nsaid: String? {
        service.account?.credential.nsaid
    }
    
    var body: some View {
        NavigationView(content: {
            ScrollViewReader(content: { scrollProxy in
                List(content: {
                    ForEach(service.schedules) { schedule in
                        NavigationLinker(destination: ShiftStatsView(schedule: schedule, nsaid: nsaid), label: {
                            ShiftView(shift: schedule)
                        })
                        .id(schedule.startTime)
                        .disabled(schedule.startTime >= Int(Date().timeIntervalSince1970))
                    }
                })
                .onFirstAppear(perform: {
                    print("FIRST APPEAR", sceneLoad, appLoad)
                })
                .onDidLoad(perform: {
                    print("DID LOAD", sceneLoad, appLoad)
                })
                .onWillAppear(perform: {
                    print("WILL APPEAR", sceneLoad, appLoad)
                })
                .onAppear(perform: {
                    print("APPEAR", sceneLoad, appLoad)
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
                withAnimation(.easeInOut(duration: 3.0)) {
                    service.schedules = service.getVisibleSchedules()
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

struct ShiftCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        ShiftCollectionView()
    }
}
