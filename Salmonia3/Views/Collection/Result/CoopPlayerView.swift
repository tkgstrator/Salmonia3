//
//  CoopPlayerView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/05/10.
//

import SwiftUI
import RealmSwift

struct CoopPlayerView: View {
    var player: RealmPlayerResult
    var isVisible: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom) {
                VStack(spacing: 3) {
                    // MARK: プレイヤーデータの表示
                    Text(player.name.stringValue(isVisible))
                        .splatfont2(.white, size: 18)
                        .frame(height: 12)
                        .padding(.bottom, 5)
                    // MARK: 支給ブキとスペシャルの表示
                    HStack {
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), alignment: .leading, spacing: 0, pinnedViews: []) {
                            Image(SpecialType.init(rawValue: player.specialId)!.image)
                                .resizable()
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
                    // MARK: 討伐したオオモノ数の表示
                    Text("RESULT_BOSS_DEFEATED_\(player.bossKillCounts.sum())")
                        .foregroundColor(.yellow)
                        .shadow(color: .black, radius: 0, x: 1, y: 1)
                }
                Spacer()
                // MARK: レーティングとマッチング回数の表示
                VStack(spacing: 0) {
                    advancedResult
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
   
    // MARK: マッチングとレーティング
    var advancedResult: some View {
        VStack(alignment: .trailing, spacing: 5) {
            HStack {
                Spacer()
                // MARK: レーティングを計算
                Text("RESULT_RATING_\(String(player.srpower))")
                    .frame(height: 10)
            }
            HStack {
                Spacer()
                // MARK: 自分自身はマッチングした回数を表示しない
                if player.isOwner {
                    Text("")
                        .frame(height: 10)
                } else {
                    Text("RESULT_MATCHING_\(String(player.matching))")
                        .frame(height: 10)
                }
            }
        }
        .frame(height: 12)
        .splatfont2(.orange, size: 13)
    }
}

extension Optional where Wrapped == String {
    func stringValue(_ isVisible: Bool) -> String {
        if isVisible { return self.stringValue }
        return "-"
    }
}

extension RealmPlayerResult {
    var isOwner: Bool {
        return self.result.first?.player.first!.pid == self.pid
    }
}
