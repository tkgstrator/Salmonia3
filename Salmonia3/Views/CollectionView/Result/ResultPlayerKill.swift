//
//  ResultPlayerKill.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/26.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet2
import SwiftyUI

struct ResultPlayerKills: View {
    let result: RealmCoopResult
    let bossCounts: [Int]
    let bossKillCounts: [[Int]]
    let bossKillCountsTotal: [Int]
    let foregroundColor = Color(hex: "FF7500")

    init(result: RealmCoopResult) {
        self.result = result
        self.bossCounts = Array(result.bossCounts)
        self.bossKillCountsTotal = sum(of: result.player.map({ Array($0.bossKillCounts)}))
        self.bossKillCounts = (result.player.map({ Array($0.bossKillCounts) })).transposed()
    }

    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 0), count: 1), spacing: 10, content: {
            ForEach(Range(0...8), id: \.self) { bossId in
                HStack(content: {
                    Image(BossId.allCases[bossId])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45)
                        .background(Circle())
                    ForEach(bossKillCounts[bossId], id: \.self) { bossKillCount in
                        Text("x\(bossKillCount)")
                            .font(systemName: .Splatfont2, size: 18)
                            .frame(maxWidth: .infinity)
                    }
                    Text("\(bossKillCountsTotal[bossId])/\(bossCounts[bossId])")
                        .font(systemName: .Splatfont2, size: 17, foregroundColor: bossCounts[bossId] == bossKillCountsTotal[bossId] ? Color.orange : Color.primary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                })
                Divider()
            }
        })
        .padding()
        .background(Color.secondary.opacity(0.3))
    }
}

extension Collection where Self.Iterator.Element: RandomAccessCollection {
    // PRECONDITION: `self` must be rectangular, i.e. every row has equal size.
    func transposed() -> [[Self.Iterator.Element.Iterator.Element]] {
        guard let firstRow = self.first else { return [] }
        return firstRow.indices.map { index in
            self.map{ $0[index] }
        }
    }
}

private func sum<T: Numeric>(of arrays: Array<Array<T>>) -> Array<T> {
    if let first = arrays.first {
        var sum: [T] = Array(repeating: 0, count: first.count)
        let _ = arrays.map({ sum = sum.add($0) })
        return sum
    }
    return []
}

struct ResultPlayerKill_Previews: PreviewProvider {
    static var previews: some View {
        ResultPlayerKills(result: RealmCoopResult(dummy: true))
            .previewLayout(.fixed(width: 390, height: 400))
    }
}
