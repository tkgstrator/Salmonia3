//
//  BirChartView.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/07.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI
import RealmSwift
import URLImage

struct BarChartView: View {
    let player: RealmSwift.List<RealmPlayerResult>
    let colors: [Color] = [.venitianred, .deepskyblue, .salam, .turbo]
    let bossCounts: [Int]
    let playerBossKillCounts: [[Int]]
    let maxWidth: CGFloat = min(340, UIScreen.main.bounds.width - 100)
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            LazyVStack(spacing: nil, pinnedViews: [.sectionHeaders], content: {
                Section(header: PlayerHeaders(player: player), content: {
                    ForEach(Array(zip(Salmonid.allCases.indices, Salmonid.allCases)), id:\.0) { index, salmonId in
                        if bossCounts[index] > 0 {
                            HStack(alignment: .center, spacing: nil, content: {
                                Image(salmonId: salmonId.rawValue)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: 40)
                                    .padding(4)
                                    .overlay(Circle().strokeBorder(Color.white, lineWidth: 2))
                                VStack(alignment: .leading, spacing: 0, content: {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.9))
                                        .frame(width: maxWidth, height: 24)
                                        .overlay(Rectangle().stroke(Color.white, lineWidth: 2))
                                        .overlay(Text("\(bossCounts[index])").splatfont2(.primary, size: 16))
                                    HStack(alignment: .center, spacing: 0, content: {
                                        ForEach(playerBossKillCounts[index].indices, id: \.self) { playerIndex in
                                            Rectangle()
                                                .fill(colors[playerIndex])
                                                .frame(width: maxWidth * CGFloat(playerBossKillCounts[index][playerIndex]) / CGFloat(bossCounts[index]), height: 24)
                                                .overlay(Rectangle().stroke(Color.white, lineWidth: 2))
                                                .overlay(
                                                    Text("\(playerBossKillCounts[index][playerIndex])")
                                                        .splatfont2(.white, size: 16)
                                                        .shadow(color: .black, radius: 0, x: 2, y: 2),
                                                    alignment: .center)
                                        }
                                    })
                                })
                            })
                            .padding(.vertical)
                        }
                    }
                })
            })
        })
    }
}

//struct BirChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        BirChartView()
//    }
//}
