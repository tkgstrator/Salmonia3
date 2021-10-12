//
//  CoopPlayerView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/05/10.
//

import SwiftUI
import RealmSwift

struct CoopPlayerView: View {
    @EnvironmentObject var appManager: AppManager
    var player: RealmPlayerResult
    
    var playerResult: some View {
        HStack(content: {
            rightResult
            leftResult
        })
    }
    
    var rightResult: some View {
        LazyVStack(alignment: .leading, spacing: 5, content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 35, maximum: 35)), count: 3), alignment: .center, spacing: 0) {
                ForEach(player.weaponList.indices, id: \.self) { index in
                    GeometryReader { geometry in
                        Image(weaponId: player.weaponList[index])
                            .resizable()
                    }
                    .aspectRatio(contentMode: .fit)
                }
            }
            Text("RESULT_BOSS_DEFEATED_\(player.bossKillCounts.sum())")
                .splatfont2(.yellow, size: 16)
                .shadow(color: .black, radius: 0, x: 1, y: 1)
        })
            .frame(minWidth: 168)
    }
    
    var leftResult: some View {
        LazyVStack(spacing: 0, content: {
            HStack(content: {
                HStack(content: {
                    Image(.golden)
                        .resizable()
                        .frame(width: 25, height: 25, alignment: .center)
                    Spacer()
                    Text(verbatim: "x\(player.goldenIkuraNum)")
                })
                HStack(content: {
                    Image(.power)
                        .resizable()
                        .frame(width: 25, height: 25, alignment: .center)
                    Spacer()
                    Text(verbatim: "x\(player.ikuraNum)")
                })
            })
            HStack(content: {
                HStack(content: {
                    Image(.rescue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 20)
                    Spacer()
                    Text(verbatim: "x\(player.helpCount)")
                })
                HStack(content: {
                    Image(.help)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 20)
                    Spacer()
                    Text(verbatim: "x \(player.deadCount)")
                })
            })
        })
            .splatfont2(.white, size: 18)
    }
    
    var playerOverview: some View {
        HStack(alignment: .bottom, content: {
            HStack(alignment: .center, spacing: nil, content: {
                Image(specialId: player.specialId)
                    .resizable()
                    .frame(width: 25, height: 25, alignment: .center)
                    .aspectRatio(contentMode: .fit)
                Text(player.name ?? "-")
                    .visible(!appManager.isFree05 || player.isFirstPlayer && !appManager.isFree03)
                    .splatfont2(.white, size: 22)
            })
            Spacer()
            LazyVStack(alignment: .trailing, spacing: -10, content: {
                Text("RESULT_MATCHING_\(String(player.matching))")
                    .visible(!player.isFirstPlayer)
                Text("RESULT_RATING_\(String(player.srpower))")
            })
                .splatfont2(.red, size: 14)
        })
    }

    var body: some View {
        LazyVStack(alignment: .center, spacing: 0, content: {
            playerOverview
            playerResult
            Divider()
        })
    }
}
