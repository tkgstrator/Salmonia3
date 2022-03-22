//
//  RankingCollection.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/04.
//

import SwiftUI

struct RankingCollection: View {
    @StateObject var rank: RankShiftStats

    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), content: {
                ForEach(rank.records) { record in
                    StatsWave(rankEgg: record)
                        .hidden(!record.isValid)
                }
            })
        })
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("金イクラ納品数")
    }
}

fileprivate extension View {
    func hidden(_ value: Bool) -> some View {
        value ? AnyView(self.hidden()) : AnyView(self)
    }
}
//struct RankingCollection_Previews: PreviewProvider {
//    static var previews: some View {
//        RankingCollection()
//    }
//}
