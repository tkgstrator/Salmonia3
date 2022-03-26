//
//  ResultPlayerKill.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/26.
//  
//

import SwiftUI
import SplatNet2
import SwiftyUI

struct ResultPlayerKills: View {
    let result: RealmCoopResult

    var body: some View {
        ForEach(result.player) { player in
            let bossCounts: [Int] = Array(result.bossCounts)
            ResultPlayerKill(player: player, bossCounts: bossCounts)
        }
        .padding(.horizontal)
    }
}

private struct ResultPlayerKill: View {
    let player: RealmCoopPlayer
    let bossCounts: [Int]
    let foregroundColor = Color(hex: "FF7500")

    var body: some View {
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.width / 360
            ZStack(content: {
                Wavecard()
                    .fill(foregroundColor)
                    .scaledToFill()
                    .frame(width: geometry.width, height: 160 * scale, alignment: .top)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                VStack(alignment: .center, content: {
                    Text(player.name ?? "-")
                        .font(systemName: .Splatfont2, size: 16 * scale, foregroundColor: .white)
                        .shadow(color: .black, radius: 0, x: 1, y: 1)
                        .frame(height: 16 * scale, alignment: .top)
                        .padding(.bottom, 6 * scale)
                    LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 60 * scale, maximum: 140 * scale)), count: 3), spacing: 8, content: {
                        let bossKillCounts: [(BossId, Int)] = Array(zip(BossId.allCases, bossCounts))
                        ForEach(bossKillCounts, id: \.0) { bossId, count in
                            HStack(content: {
                                Image(bossId)
                                    .resizable()
                                    .scaledToFit()
                                    .background(Circle().fill(Color.black))
                                    .frame(width: 30 * scale, height: 30 * scale, alignment: .center)
                                Text(String(format: "x%02d/%02d", player.bossKillCounts(bossId: bossId), count))
                                    .font(systemName: .Splatfont2, size: 14 * scale, foregroundColor: .white)
                                    .shadow(color: .black, radius: 0, x: 1, y: 1)
                            })
                        }
                    })
                })
            })
        })
        .aspectRatio(360/160, contentMode: .fit)
    }
}

struct ResultPlayerKill_Previews: PreviewProvider {
    static var previews: some View {
        ResultPlayerKill(player: RealmCoopPlayer(dummy: true), bossCounts: Array(repeating: 99, count: 9))
    }
}
