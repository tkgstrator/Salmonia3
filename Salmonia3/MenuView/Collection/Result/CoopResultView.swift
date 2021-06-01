//
//  CoopResult.swift
//  Salmonia3
//
//  Created by Devonly on 3/19/21.
//

import SwiftUI

fileprivate var formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "yyyy MM/dd HH:mm"
    return formatter
}()

struct CoopResultView: View {
    var result: RealmCoopResult
    @State var isVisible: Bool = true

    var body: some View {
        TabView {
            CoopResultOverview(isVisible: $isVisible, result: result)
                .tag(0)
            CoopPlayerResultView(isVisible: $isVisible, result: result)
                .tag(1)
        }
        .tabViewStyle(PageTabViewStyle())
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CoopResultOverview: View {
    @Binding var isVisible: Bool
    @AppStorage("FEATURE_FREE_03") var isFree03: Bool = false
    var result: RealmCoopResult

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ResultOverview
                    .padding(.bottom, 20)
                ResultWave
                    .padding(.bottom, 40)
                ResultPlayer
                    .padding(.bottom, 50)
            }
        }
        .backgroundColor(.black)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: SRButton)
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
            }
        }
    }

    // MARK: 概要を表示するビュー
    var ResultOverview: some View {
        ZStack(alignment: .center) {
            Image(StageType(rawValue: result.stageId.intValue)!.md5)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 8.0))
                .frame(height: 120)
                .mask(Image("2ce11ebf110993621bedd8e747d7b1b").resizable())
            VStack(spacing: 0) {
                // MARK: プレイ時間の表示
                Text(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(result.playTime))))
                    .shadow(color: .black, radius: 0, x: 2, y: 2)
                    .splatfont2(.white, size: 22)
                // MARK: キケン度の表示
                DangerRate
                // MARK: イクラ数の表示
                HStack {
                    Image("49c944e4edf1abee295b6db7525887bd")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                    Text(verbatim: "x\(result.goldenEggs.intValue)")
                    Image("f812db3e6de0479510cd02684131e15a")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                    Text(verbatim: "x\(result.powerEggs.intValue)")
                }
                .shadow(color: .black, radius: 0, x: 1, y: 1)
            }
        }
        .splatfont2(.white, size: 20)
    }

    // MARK: 各WAVEの情報を表示
    var ResultWave: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 140), alignment: .top), count: result.wave.count)) {
            ForEach(result.wave.indices, id: \.self) { index in
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Text("RESULT_WAVE_\(index + 1)")
                            .foregroundColor(.black)
                        Text("\(result.wave[index].goldenIkuraNum)/\(result.wave[index].quotaNum)")
                            .foregroundColor(.white)
                            .padding(.horizontal, 5)
                            .frame(maxWidth: .infinity)
                            .frame(height: 36)
                            .background(Color.dark)
                            .splatfont2(size: 26)
                        Text("\(result.wave[index].ikuraNum)")
                            .foregroundColor(.red)
                        Text(result.wave[index].waterLevel.stringValue.localized)
                            .frame(height: 24)
                            .foregroundColor(.black)
                        Text(result.wave[index].eventType.stringValue.localized)
                            .frame(height: 24)
                            .foregroundColor(.black)
                    }
                    .background(Color.yellow)
                    .clipShape(RoundedRectangle(cornerRadius: 3))
                    HStack {
                        Image("49c944e4edf1abee295b6db7525887bd")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text("RESULT_APPEARANCES_\(result.wave[index].goldenIkuraPopNum)")
                    }
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), alignment: .leading, spacing: 0, pinnedViews: []) {
                        ForEach(result.specialUsage[index].indices) { idx in
                            Image(SpecialType.init(rawValue: result.specialUsage[index][idx])!.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 28)
                        }
                    }
                }
            }
        }
        .frame(height: 180)
        .splatfont2(.white, size: 16)
        .padding(.horizontal, 5)
    }

    // MARK: 各プレイヤーの情報を表示
    var ResultPlayer: some View {
        LazyHGrid(rows: Array(repeating: .init(.flexible(minimum: 80)), count: result.player.count), spacing: 10) {
            ForEach(result.player.indices, id: \.self) { index in
                // MARK: 表示させるかどうかのフラグをつける
                CoopPlayerView(player: result.player[index], isVisible: (isVisible || (index == 0 && !isFree03)))
                    .padding(.vertical, 15)
            }
        }
    }

    // MARK: キケン度を表示
    var DangerRate: some View {
        switch result.dangerRate.value! == 200 {
        case true:
            return Text(.RESULT_HAZARD_LEVEL_MAX)
                .splatfont2(.yellow, size: 20)
        case false:
            return Text("RESULT_HAZARD_LEVEL_\(String(result.dangerRate.value!))")
                .splatfont2(.yellow, size: 20)
        }

    }
}


