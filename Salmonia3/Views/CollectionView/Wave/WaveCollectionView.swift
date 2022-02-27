//
//  WaveCollection.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/27.
//

import SwiftUI
import RealmSwift

struct WaveCollectionView: View {
    @ObservedResults(RealmCoopWave.self, sortDescriptor: SortDescriptor(keyPath: "goldenIkuraNum", ascending: false)) var waves
    
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
        })
        
    }
}

struct WaveCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        WaveCollectionView()
    }
}
