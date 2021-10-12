//
//  CircleChartView.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/07.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftUIX
import RealmSwift
import URLImage

struct CircleChartView: View {
    let player: RealmSwift.List<RealmPlayerResult>
    let colors: [Color] = [.venitianred, .deepskyblue, .salam, .turbo]
    let bossCounts: [Int]
    let playerBossKillCounts: [[Int]]
    
    func bossResult(salmonId: SalmonidType) -> some View {
        EmptyView()
//        LazyVGrid(columns: Array(repeating: .init(.adaptive(minimum: 60)), count: player.count), alignment: .center, spacing: 5, pinnedViews: [], content: {
//            ForEach(playerBossKillCounts[index].indices, id:\.self) { playerIndex in
//                Circle()
//                    .trim(from: 0.0, to: CGFloat(playerBossKillCounts[index][playerIndex]) / CGFloat(playerBossKillCounts[index].max()!))
//                    .stroke(playerBossKillCounts[index][playerIndex] == playerBossKillCounts[index].max()! ? Color.safetyorange : Color.dodgerblue, lineWidth: 6)
//                    .frame(width: 60, height: 60)
//                    .rotationEffect(.degrees(-90))
//                    .background(Circle().stroke(Color.gray.opacity(0.5), lineWidth: 6))
//                    .overlay(
//                        Image(salmonId: salmonId.rawValue)
//                            .resizable()
//                            .opacity(0.5)
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 50, height: 50)
//                            .background(Circle().fill(Color.black.opacity(0.5)))
//                    )
//                    .overlay(
//                        Text("\(playerBossKillCounts[index][playerIndex])")
//                            .splatfont2(.white, size: 28)
//                            .shadow(color: .black, radius: 0, x: 2, y: 2),
//                        alignment: .center
//                    )
//                    .padding(8)
//            }
//        })
//        .padding(.horizontal)
    }
    
    var playerResult: some View {
        VStack(alignment: .center, spacing: nil, content: {
            ForEach(Array(zip(SalmonidType.allCases.indices, SalmonidType.allCases)), id:\.0) { index, salmonId in
                if bossCounts[index] > 0 {
                    bossResult(salmonId: salmonId)
                }
            }
        })
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
