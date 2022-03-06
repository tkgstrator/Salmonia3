//
//  RankingCollection.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/04.
//

import SwiftUI

struct RankingCollection: View {
    @StateObject var stats: RankShiftStats
    
    init(startTime: Int, nsaid: String?) {
        self._stats = StateObject(wrappedValue: RankShiftStats(startTime: startTime, nsaid: nsaid))
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), content: {
                ForEach(stats.goldenEggs) { record in
                    if let available = record.total {
                        StatsWave(rankEgg: record)
                    }
                }
            })
        })
            .padding(.horizontal)
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("金イクラ納品数")
    }
}

//struct RankingCollection_Previews: PreviewProvider {
//    static var previews: some View {
//        RankingCollection()
//    }
//}
