//
//  CircleChartView.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/07.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI
import RealmSwift
import URLImage

struct CircleChartView: View {
    let player: RealmSwift.List<RealmPlayerResult>
    let colors: [Color] = [.venitianred, .deepskyblue, .salam, .turbo]
    let bossCounts: [Int]
    let playerBossKillCounts: [[Int]]
    
    var playerResult: some View {
        ForEach(Array(zip(Salmonid.allCases.indices, Salmonid.allCases)), id:\.0) { index, salmonId in
            if bossCounts[index] > 0 {
                LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 60, maximum: 100)), count: player.count), alignment: .center, spacing: 5, pinnedViews: [], content: {
                    ForEach(playerBossKillCounts[index].indices, id:\.self) { playerIndex in
                        Circle()
                            .trim(from: 0.0, to: CGFloat(playerBossKillCounts[index][playerIndex]) / CGFloat(playerBossKillCounts[index].max()!))
                            .stroke(playerBossKillCounts[index][playerIndex] == playerBossKillCounts[index].max()! ? Color.safetyorange : Color.dodgerblue, lineWidth: 6)
                            .rotationEffect(.degrees(-90))
                            .frame(width: 80, height: 80)
                            .background(Circle().stroke(Color.gray.opacity(0.5), lineWidth: 6))
                            .overlay(
                                Image(salmonId: salmonId.rawValue)
                                    .resizable()
                                    .opacity(0.5)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .background(Circle().fill(Color.black.opacity(0.5)))
                            )
                            .overlay(
                                Text("\(playerBossKillCounts[index][playerIndex])")
                                    .splatfont2(.white, size: 28)
                                    .shadow(color: .black, radius: 0, x: 2, y: 2),
                                alignment: .center
                            )
                            .padding(8)
                    }
                })
                .padding(.horizontal)
            }
        }
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            LazyVStack(spacing: nil, pinnedViews: [.sectionHeaders], content: {
                Section(header: PlayerHeaders(player: player), content: {
                    playerResult
                })
            })
        })
    }
}

//struct CircleChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        CircleChartView()
//    }
//}
