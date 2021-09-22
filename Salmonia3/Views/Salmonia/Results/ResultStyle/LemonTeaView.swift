//
//  LemonTeaView.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/07.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI
import RealmSwift
import URLImage

struct LemonTeaView: View {
    let result: RealmCoopResult
    let maxWidth: CGFloat = min(340, UIScreen.main.bounds.width - 100)
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            LazyVStack(alignment: .center, spacing: nil, pinnedViews: [], content: {
                playerResult
                defeatedGraph
                goldenEggGraph
                //                .overlay(backgroundGraph, alignment: .bottom)
            })
        })
    }
    
    var playerResult: some View {
        ForEach(Array(result.player), id:\.self) { player in
            LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 60, maximum: 120)), count: 4), alignment: .center, spacing: nil, pinnedViews: [], content: {
                URLImage(url: player.thumbnailURL, content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 36, height: 36)
                        .mask(Circle())
                })
                Text(player.name.stringValue)
                Text("\(player.bossKillCounts.sum())")
                Text("\(player.goldenIkuraNum)")
            })
            .splatfont2(.seashell, size: 18)
            Image(ResultIcon.dot)
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
    
    var backgroundGraph: some View {
        Rectangle().fill(Color.gray).frame(width: maxWidth, height: 2)
            .overlay(
                LazyVGrid(columns: Array(repeating: .init(.fixed(maxWidth / 7)), count: 7), alignment: .center, spacing: nil, pinnedViews: [], content: {
                    ForEach([0, 10, 20, 30, 40, 50, 66], id:\.self) { index in
                        Text("\(index)")
                            .splatfont2(.safetyorange, size: 10)
                    }
                }),
                alignment: .bottom
            )
    }
    
    var defeatedGraph: some View {
        LazyVStack(alignment: .leading, spacing: nil, pinnedViews: [], content: {
            ForEach(Array(result.player), id:\.self) { player in
                HStack(alignment: .center, spacing: nil, content: {
                    URLImage(url: player.thumbnailURL, content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 36, height: 36)
                            .mask(Circle())
                    })
                    HStack(alignment: .center, spacing: nil, content: {
                        Rectangle().fill(Color.easternblue).frame(width: maxWidth * CGFloat(player.bossKillCounts.sum()) / CGFloat(66), height: 13)
                        Text(String(format: "%.02f%%",  100 * CGFloat(player.bossKillCounts.sum()) / CGFloat(result.bossCounts.sum())))
                            .splatfont2(.seashell, size: 15)
                    })
                    Spacer()
                })
            }
        })
        .overlay(backgroundGraph, alignment: .bottom)
    }
    
    var goldenEggGraph: some View {
        ForEach(Array(result.player), id:\.self) { player in
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), alignment: .leading, spacing: nil, pinnedViews: [], content: {
                URLImage(url: player.thumbnailURL, content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 36, height: 36)
                        .mask(Circle())
                })
                HStack(alignment: .center, spacing: nil, content: {
                    Rectangle().fill(Color.moonyellow).frame(width: maxWidth * CGFloat(player.goldenIkuraNum) / CGFloat(200), height: 13)
                    Text(String(format: "%.02f%%",  100 * CGFloat(player.goldenIkuraNum) / CGFloat(result.goldenEggs)))
                        .splatfont2(.seashell, size: 15)
                })
            })
        }
    }
}

//struct LemonTeaView_Previews: PreviewProvider {
//    static var previews: some View {
//        LemonTeaView()
//    }
//}
