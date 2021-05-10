//
//  CoopPlayerView.swift
//  Salmonia3
//
//  Created by devonly on 2021/05/10.
//

import SwiftUI
import RealmSwift

struct CoopPlayerView: View {
    var player: RealmPlayerResult
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom) {
                VStack(spacing: 3) {
                    Text(player.name.stringValue)
                        .splatfont2(.white, size: 18)
                        .frame(height: 10)
                        .padding(.bottom, 5)
                    HStack {
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), alignment: .leading, spacing: 0, pinnedViews: []) {
                            SRImage(from: Special(rawValue: player.specialId), size: CGSize(width: 35, height: 35))
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 35)
                            ForEach(player.weaponList.indices, id: \.self) { index in
                                Image(String(player.weaponList[index]).imageURL)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 35)
                            }
                        }
                    }
                    Text("RESULT_BOSS_DEFEATED_\(player.bossKillCounts.sum())")
                        .foregroundColor(.yellow)
                        .shadow(color: .black, radius: 0, x: 1, y: 1)
                }
                Spacer()
                VStack(spacing: 0) {
                    Spacer()
                    HStack {
                        HStack {
                            Image("49c944e4edf1abee295b6db7525887bd")
                                .resizable()
                                .frame(width: 15, height: 15)
                            Spacer()
                            Text(verbatim: "x \(player.goldenIkuraNum)")
                        }
                        HStack {
                            Image("f812db3e6de0479510cd02684131e15a")
                                .resizable()
                                .frame(width: 15, height: 15)
                            Spacer()
                            Text(verbatim: "x \(player.ikuraNum)")
                        }
                    }
                    HStack {
                        HStack {
                            Image("657f8b8da628ef83cf69101b6817150a")
                                .resizable()
                                .frame(width: 33.4, height: 12.8)
                            Spacer()
                            Text(verbatim: "x \(player.helpCount)")
                        }
                        HStack {
                            Image("2e8d6dbf9112a879d4ceb15403d10a78")
                                .resizable()
                                .frame(width: 33.4, height: 12.8)
                            Spacer()
                            Text(verbatim: "x \(player.deadCount)")
                        }
                    }
                }
            }
        }
        .splatfont2(.white, size: 16)
        .frame(height: 80)
    }
}
