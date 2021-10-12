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
    
    var weaponList: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 20, maximum: 35)), count: 4), alignment: .leading, spacing: 0) {
            Image(specialId: player.specialId)
                .resizable()
                .aspectRatio(contentMode: .fit)
            ForEach(player.weaponList.indices, id: \.self) { index in
                Image(weaponId: player.weaponList[index])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .frame(minWidth: 80)
    }
    
    var eggResult: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 40, maximum: 80)), count: 2), alignment: .center, spacing: 0, pinnedViews: [], content: {
            HStack(content: {
                Image(.golden)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 20)
                Spacer()
                Text(verbatim: "x \(player.goldenIkuraNum)")
            })
            HStack(content: {
                Image(.rescue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 20)
                Spacer()
                Text(verbatim: "x \(player.helpCount)")
            })
            HStack(content: {
                Image(.power)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 20)
                Spacer()
                Text(verbatim: "x \(player.ikuraNum)")
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
    }
    
    var body: some View {
        LazyVStack(alignment: .center, spacing: 0) {
            HStack(alignment: .firstTextBaseline, spacing: nil, content: {
                Text((appManager.isFree05 || !(appManager.isFree03 && !player.isFirstPlayer)) ? player.name.stringValue : "-")
                    .splatfont2(.white, size: 18)
                    .padding(.leading)
                Spacer()
                VStack(alignment: .trailing, spacing: 5) {
                    HStack(content: {
                        Spacer()
                        Text("RESULT_RATING_\(String(player.srpower))")
                            .frame(height: 10)
                    })
                    HStack(content: {
                        Spacer()
                        Text(player.isFirstPlayer ? "" : "RESULT_MATCHING_\(String(player.matching))")
                    })
                }
                .frame(height: 12)
                .minimumScaleFactor(1.0)
                .splatfont2(.safetyorange, size: 13)
            })
                .frame(height: 54)
            HStack(alignment: .top, spacing: nil, content: {
                VStack(content: {
                    weaponList
                    Text("RESULT_BOSS_DEFEATED_\(player.bossKillCounts.sum())")
                        .foregroundColor(.yellow)
                        .shadow(color: .black, radius: 0, x: 1, y: 1)
                })
                eggResult
            })
        }
        //            .frame(width: geometry.frame(in: .global).width)
        .splatfont2(.white, size: 16)
    }
}
