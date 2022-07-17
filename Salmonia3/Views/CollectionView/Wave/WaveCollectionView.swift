//
//  WaveCollection.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/27.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import RealmSwift
import SplatNet2
import SwiftyUI

struct WaveCollectionView: View {
//    @StateObject var service: WaveService = WaveService()
    @ObservedResults(
        RealmCoopWave.self,
        filter: nil,
        sortDescriptor: SortDescriptor(keyPath: "goldenIkuraNum", ascending: false)
    )
    var waves
    @State private var waterLevel: WaterId? = .none
    @State private var eventType: EventId? = .none

    func filter(eventType: EventId?, waterLevel: WaterId?) {
        switch (eventType, waterLevel) {
        case (.none, .none):
            $waves.filter = nil
        case (.none, .some(let waterLevel)):
            $waves.filter = NSPredicate("waterLevel", equal: waterLevel.key)
        case (.some(let eventType), .none):
            $waves.filter = NSPredicate("eventType", equal: eventType.key)
        case (.some(let eventType), .some(let waterLevel)):
            $waves.filter = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate("waterLevel", equal: waterLevel.key), NSPredicate("eventType", equal: eventType.key)])
        }
    }
    
    var body: some View {
        NavigationView(content: {
            ScrollViewReader(content: { proxy in
                List(content: {
                    ForEach(waves) { wave in
                        NavigationLinker(destination: ResultView(wave), label: {
                            WaveView(wave: wave)
                        })
                    }
                })
            })
                .listStyle(.plain)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("WAVE一覧")
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        StageIdFilterView(selection: $waterLevel)
                    })
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        EventTypeFilterView(selection: $eventType)
                    })
                })
                .onChange(of: eventType, perform: { eventType in
                    filter(eventType: eventType, waterLevel: waterLevel)
                })
                .onChange(of: waterLevel, perform: { waterLevel in
                    filter(eventType: eventType, waterLevel: waterLevel)
                })
        })
        .navigationViewStyle(.split)
    }
}

struct EventTypeFilterView: View {
    @State private var isPresented: Bool = false
    @Binding var selection: EventId?

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Image(systemName: .CloudRain)
        })
        .halfsheet(isPresented: $isPresented, onDismiss: {
        }, content: {
            Picker(selection: $selection, content: {
                Text("None")
                    .tag(Optional<EventId>.none)
                ForEach(EventId.allCases) { eventType in
                    Text(eventType)
                        .tag(eventType as? EventId)
                }
            }, label: {})
            .pickerStyle(.wheel)
        })
    }
}

struct StageIdFilterView: View {
    @State private var isPresented: Bool = false
    @Binding var selection: WaterId?
    
    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Image(systemName: .Line3HorizontalDecreaseCircle)
        })
        .halfsheet(isPresented: $isPresented, content: {
            Picker(selection: $selection, content: {
                Text("None")
                    .tag(Optional<WaterId>.none)
                ForEach(WaterId.allCases) { waterLevel in
                    Text(waterLevel)
                        .tag(waterLevel as? WaterId)
                }
            }, label: {})
            .pickerStyle(.wheel)
        })
    }
}

//struct WaveCollectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        WaveCollectionView()
//    }
//}
