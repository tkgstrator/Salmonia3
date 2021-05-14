//
//  CoopPlayerResultView.swift
//  Salmonia3
//
//  Created by devonly on 2021/05/10.
//

import SwiftUI
import RealmSwift

struct CoopPlayerResultView: View {
    var result: RealmCoopResult
    @Binding var isVisible: Bool

    var body: some View {
        List {
            Section(header: Text("RESULT_PLAYER").splatfont2(.orange, size: 14)) {
                HStack(alignment: .top, spacing: 0) {
                    Text("").frame(width: 30)
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: result.player.count), alignment: .center, spacing: 0, pinnedViews: []) {
                        ForEach(result.player.indices, id: \.self) { index in
                            VStack {
                                Image(systemName: "circle")
                                Text(result.player[index].name.stringValue)
                                    .splatfont2(size: 12)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            Section(header: Text("RESULT_SALMONIDS").splatfont2(.orange, size: 14)) {
                ForEach(Range(0...8)) { id in
                    if result.bossCounts[id] != 0 {
                        HStack(spacing: 0) {
                            VStack(spacing: 0) {
                                SRImage(from: Salmonid(rawValue: id), size: CGSize(width: 30, height: 30))
                                    .frame(width: 30, height: 30)
                                if result.bossKillCounts[id] == result.bossCounts[id] {
                                    Text("\(result.bossKillCounts[id])/\(result.bossCounts[id])")
                                        .splatfont2(.yellow, size: 14)
                                        .shadow(color: .black, radius: 0, x: 1, y: 1)
                                        .frame(width: 40, height: 16)
                                } else {
                                    Text("\(result.bossKillCounts[id])/\(result.bossCounts[id])")
                                        .splatfont2(size: 14)
                                        .frame(width: 40, height: 16)
                                }
                            }
                            .frame(width: 30)
                            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: result.player.count), alignment: .center, spacing: nil, pinnedViews: []) {
                                ForEach(result.player.indices, id: \.self) { index in
                                    if result.player[index].bossKillCounts[id] == result.player.map { $0.bossKillCounts[id] }.max() {
                                        Text("\(result.player[index].bossKillCounts[id])")
                                            .splatfont2(.yellow, size: 18)
                                            .shadow(color: .black, radius: 0, x: 1, y: 1)
                                    } else {
                                        Text("\(result.player[index].bossKillCounts[id])")
                                            .splatfont2(size: 18)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            Section(header: Text("RESULT_EVALUATION").splatfont2(.orange, size: 14)) {
                HStack(spacing: 0) {
                    Text("RESULT_KILL_COUNT")
                        .frame(width: 30)
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: result.player.count), alignment: .center, spacing: nil, pinnedViews: []) {
                        ForEach(result.player.indices, id: \.self) { index in
                            Text("\(result.player[index].bossKillCounts.sum())")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                HStack(spacing: 0) {
                    Text("RESULT_EGG_COUNT")
                        .frame(width: 30)
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: result.player.count), alignment: .center, spacing: nil, pinnedViews: []) {
                        ForEach(result.player.indices, id: \.self) { index in
                            Text("\(result.player[index].goldenIkuraNum)")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                EmptyView()
                    .padding(.bottom, 50)
            }
            .splatfont2(size: 16)
        }

    }

    var Header: some View {
        HStack {
            ForEach(result.player, id: \.self) { player in
                VStack(spacing: 0) {
                    Image(systemName: "circle")
                    Text(isVisible ? player.name.stringValue : "-")
                        .lineLimit(1)
                }
                .font(.custom("Splatfont2", size: 12))
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.leading, 45)
    }
}
