//
//  WaveCollection.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/27.
//

import SwiftUI
import RealmSwift
import SplatNet2
import SwiftyUI

struct WaveCollectionView: View {
    @ObservedResults(RealmCoopWave.self, sortDescriptor: SortDescriptor(keyPath: "goldenIkuraNum", ascending: false)) var waves

    @State private var stageId: StageId?
    @State private var eventType: EventId?
    @State private var waterLevel: WaterId?
    
    
    var body: some View {
        NavigationView(content: {
            List(content: {
                ForEach(waves) { wave in
                    NavigationLinker(destination: ResultView(wave.result), label: {
                        WaveView(wave: wave)
                    })
                }
            })
                .listStyle(.plain)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("WAVE一覧")
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading, content: {
                        StageIdFilterView()
                    })
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        EventTypeFilterView()
                    })
                })
        })
        
    }
    
    struct EventTypeFilterView: View {
        @State private var isPresented: Bool = false
        @State private var selection: WaterId? = .none
        
        var body: some View {
            Button(action: {
                isPresented.toggle()
            }, label: {
                Image(systemName: .CloudRain)
            })
            .halfsheet(isPresented: $isPresented, content: {
                Picker(selection: $selection, content: {
                    Text("None")
                    ForEach(EventId.allCases) { eventType in
                        Text(eventType)
                    }
                }, label: {})
                .pickerStyle(.wheel)
            })
        }
    }
    
    struct StageIdFilterView: View {
        @State private var isPresented: Bool = false
        @State private var selection: StageId? = .none
        
        var body: some View {
            Button(action: {
                isPresented.toggle()
            }, label: {
                Image(systemName: .Line3HorizontalDecreaseCircle)
            })
            .halfsheet(isPresented: $isPresented, content: {
                Picker(selection: $selection, content: {
                    Text("None")
                    ForEach(StageId.allCases) { stageId in
                        Text(stageId)
                    }
                }, label: {})
                .pickerStyle(.wheel)
            })
        }
    }
}

struct WaveCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        WaveCollectionView()
    }
}
