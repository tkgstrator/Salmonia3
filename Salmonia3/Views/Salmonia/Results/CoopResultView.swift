//
//  CoopResult.swift
//  Salmonia3
//
//  Created by tkgstrator on 3/19/21.
//

import SwiftUI
import SwiftUIX

fileprivate var formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "yyyy MM/dd HH:mm"
    return formatter
}()

struct CoopResultView: View {
    @State var isVisible: Bool = true
    @State var selection: Int = 0
    var result: RealmCoopResult

    var body: some View {
        PaginationView {
            CoopResultOverview(isVisible: $isVisible, result: result)
            CoopPlayerResultView(result: result)
        }
        .currentPageIndex($selection)
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CoopResultSimpleView: View {
    @State var isVisible: Bool = true
    var result: RealmCoopResult

    var body: some View {
        CoopResultOverview(isVisible: $isVisible, result: result)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationTitle(.TITLE_RESULT_DETAIL)
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct CoopResultOverview: View {
    @Binding var isVisible: Bool
    @AppStorage("FEATURE_FREE_03") var isHidden: Bool = false
    var result: RealmCoopResult

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ResultOverview
                    .padding(.bottom, 10)
                ResultWave
                    .padding(.bottom, 10)
                ResultPlayer
            }
        }
        .navigationTitle(.TITLE_RESULT_DETAIL)
    }

    // 切り替え用のボタン
    var SRButton: some View {
        HStack {
            Button(action: { isVisible.toggle() }) {
                Image(systemName: "person.circle.fill")
                    .imageScale(.large)
                    .grayscale(isVisible ? 1.0 : 0.99)
                    .opacity(isVisible ? 1.0 : 0.5)
                    .padding(.all, 10)
            }
        }
    }

    // MARK: 概要を表示するビュー
    var ResultOverview: some View {
        ZStack(alignment: .center) {
            Image(stageId: result.stageId)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 8.0))
                .frame(height: 120)
                .mask(Image(.wave).resizable())
//                .mask(Image("2ce11ebf110993621bedd8e747d7b1b").resizable())
            LazyVStack(spacing: 0) {
                // MARK: プレイ時間の表示
                Text(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(result.playTime))))
                    .shadow(color: .black, radius: 0, x: 2, y: 2)
                    .splatfont2(.white, size: 22)
                // MARK: キケン度の表示
                DangerRate
                // MARK: イクラ数の表示
                LazyHStack {
                    Image(Egg.golden)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                    Text(verbatim: "x\(result.goldenEggs)")
                    Image(Egg.power)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                    Text(verbatim: "x\(result.powerEggs)")
                }
                .shadow(color: .black, radius: 0, x: 1, y: 1)
            }
        }
        .overlay(SRButton, alignment: .topTrailing)
        .splatfont2(.white, size: 20)
    }

    // MARK: 各WAVEの情報を表示
    var ResultWave: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 140), alignment: .top), count: result.wave.count)) {
            ForEach(result.wave.indices, id: \.self) { index in
                LazyVStack(spacing: 0) {
                    LazyVStack(spacing: 0) {
                        Text("RESULT_WAVE_\(index + 1)")
                            .foregroundColor(.black)
                        Text("\(result.wave[index].goldenIkuraNum)/\(result.wave[index].quotaNum)")
                            .foregroundColor(.white)
                            .padding(.horizontal, 5)
                            .frame(maxWidth: .infinity)
                            .frame(height: 36)
                            .background(Color.maire)
                            .splatfont2(size: 26)
                        Text("\(result.wave[index].ikuraNum)")
                            .foregroundColor(.red)
                        Text(result.wave[index].waterLevel.localized)
                            .frame(height: 24)
                            .foregroundColor(.black)
                        Text(result.wave[index].eventType.localized)
                            .frame(height: 24)
                            .foregroundColor(.black)
                    }
                    .background(Color.yellow)
                    .clipShape(RoundedRectangle(cornerRadius: 3))
                    .padding(.bottom, 10)
                    LazyHStack {
                        Image(Egg.golden)
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text("RESULT_APPEARANCES_\(result.wave[index].goldenIkuraPopNum)")
                            .font(.custom("Splatfont2", size: 13))
                            .minimumScaleFactor(0.5)
                    }
                    .padding(.bottom, 10)
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), alignment: .leading, spacing: 0, pinnedViews: []) {
                        ForEach(result.specialUsage[index].indices) { idx in
                            Image(specialId: result.specialUsage[index][idx])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 28)
                        }
                    }
                }
            }
        }
        .frame(minHeight: 120)
        .splatfont2(.white, size: 16)
        .padding(.horizontal, 5)
    }

    // MARK: 各プレイヤーの情報を表示
    var ResultPlayer: some View {
        LazyHGrid(rows: Array(repeating: .init(.flexible(minimum: 80)), count: result.player.count), spacing: 10) {
            ForEach(result.player.indices, id: \.self) { index in
                // MARK: 表示させるかどうかのフラグをつける
                NavigationLink(destination: PlayerResultsView(player: result.player[index])) {
                    CoopPlayerView(player: result.player[index], isVisible: (isVisible || (index == 0 && !isHidden)))
                        .padding(.vertical, 15)
                }
            }
        }
    }

    // MARK: キケン度を表示
    var DangerRate: some View {
        switch result.dangerRate == 200 {
        case true:
            return Text(.RESULT_HAZARD_LEVEL_MAX)
                .splatfont2(.yellow, size: 20)
        case false:
            return Text("RESULT_HAZARD_LEVEL_\(String(result.dangerRate))")
                .splatfont2(.yellow, size: 20)
        }
    }
}


