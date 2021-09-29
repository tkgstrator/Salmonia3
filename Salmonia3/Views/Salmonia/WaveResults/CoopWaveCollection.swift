//
//  CoopWaveCollection.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/06/04.
//

import SwiftUI
import RealmSwift

struct CoopWaveCollection: View {
    @ObservedResults(RealmCoopWave.self, sortDescriptor: SortDescriptor(keyPath: "goldenIkuraNum", ascending: false)) var waves

    var body: some View {
        List {
            ForEach(waves) { wave in
                ZStack(alignment: .leading) {
                    NavigationLink(destination: CoopResultView(result: wave.result.first!)) {
                        EmptyView()
                    }
                    .opacity(0.0)
                    WaveOverview()
                        .environment(\.wave, CoopWave(from: wave))
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(.TITLE_WAVE_COLLECTION)
    }
}


struct CoopWaveCollection_Previews: PreviewProvider {
    static var previews: some View {
        CoopWaveCollection()
    }
}
