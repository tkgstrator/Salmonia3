//
//  ResultCollectionView.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/24.
//

import SwiftUI
import SwiftyUI
import RealmSwift
import Alamofire

struct ResultCollectionView: View {
    @EnvironmentObject var service: AppService
    @ObservedResults(RealmCoopShift.self, sortDescriptor: SortDescriptor(keyPath: "startTime", ascending: false)) var schedules
    @State var isPresented: Bool = false
    
    var body: some View {
        NavigationView(content: {
            List(content: {
                ForEach(schedules) { schedule in
                    if !schedule.results.isEmpty {
                        ResultShiftView(schedule: schedule)
                    }
                }
            })
            .listStyle(.plain)
            .refreshable(action: {
                isPresented.toggle()
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("リザルト一覧")
            .fullScreenCover(isPresented: $isPresented, content: {
                LoadingView()
            })
        })
        .navigationViewStyle(.split)
    }
}

struct ResultCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        ResultCollectionView()
    }
}

/// ListやFrom内で使用したときにIndicatorを非表示にする
struct NavigationLinker<Destination: View, Label: View>: View {
    let destination: Destination
    let label: () -> Label
    
    init(destination: Destination, label: @escaping () -> Label) {
        self.destination = destination
        self.label = label
    }
    
    var body: some View {
        ZStack(content: {
            NavigationLink(destination: destination, label: {
                EmptyView()
            })
            .opacity(0.0)
            label()
        })
    }
}
