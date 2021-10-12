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
            CoopResultOverview(result: result)
            CoopPlayerResultView(result: result)
        }
        .currentPageIndex($selection)
        .background(Color.black)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CoopResultSimpleView: View {
    var result: RealmCoopResult
    
    var body: some View {
        CoopResultOverview(result: result)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationTitle(.TITLE_RESULT_DETAIL)
            .navigationBarTitleDisplayMode(.inline)
    }
}

private struct CoopResultOverview: View {
    @EnvironmentObject var appManager: AppManager
    var result: RealmCoopResult
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10, content: {
                ResultOverview
                ResultWave
                ResultPlayer
            })
        }
        .navigationTitle(.TITLE_RESULT_DETAIL)
    }
    
    var ResultOverview: some View {
        LazyVStack(alignment: .center, spacing: 0, content: {
            Text(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(result.playTime))))
                .shadow(color: .black, radius: 0, x: 2, y: 2)
                .splatfont2(.white, size: 20)
            switch result.dangerRate == 200 {
                case true:
                    Text(.RESULT_HAZARD_LEVEL_MAX)
                        .splatfont2(.yellow, size: 20)
                case false:
                    Text("RESULT_HAZARD_LEVEL_\(String(result.dangerRate))")
                        .splatfont2(.yellow, size: 20)
            }
            HStack(content: {
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
            })
                .shadow(color: .black, radius: 0, x: 1, y: 1)
                .splatfont2(.white, size: 20)
        })
            .background(Image(stageId: result.stageId).resizable().aspectRatio(contentMode: .fill))
            .frame(height: 120)
    }
    
    var ResultWave: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 140), alignment: .top), count: result.wave.count)) {
            ForEach(result.wave) { wave in
                VStack(alignment: .center, spacing: 0, content: {
                    VStack(spacing: 0, content: {
                        Text("RESULT_WAVE_\(wave.index + 1)")
                            .foregroundColor(.black)
                        Text("\(wave.goldenIkuraNum)/\(wave.quotaNum)")
                            .foregroundColor(.white)
                            .splatfont2(size: 22)
                            .frame(maxWidth: .infinity)
                            .frame(height: 36)
                            .minimumScaleFactor(1.0)
                            .backgroundFill(.maire)
                        Text("\(wave.ikuraNum)")
                            .foregroundColor(.red)
                            .frame(height: 26)
                            .minimumScaleFactor(1.0)
                        Text(wave.waterLevel.localizedName)
                            .foregroundColor(.black)
                            .frame(height: 26)
                            .minimumScaleFactor(1.0)
                        Text(wave.eventType.localizedName)
                            .foregroundColor(.black)
                            .frame(height: 26)
                            .minimumScaleFactor(1.0)
                    })
                        .background(RoundedRectangle(cornerRadius: 4).fill(Color.yellow))
                        .frame(minHeight: 140)
                    HStack(content: {
                        Image(Egg.golden)
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text("RESULT_APPEARANCES_\(wave.goldenIkuraPopNum)")
                            .font(.custom("Splatfont2", size: 13))
                            .minimumScaleFactor(0.5)
                    })
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), alignment: .leading, spacing: 0, pinnedViews: []) {
                        ForEach(wave.specialUsage.indices) { index in
                            Image(specialId: wave.specialUsage[index])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                })
            }
        }
        .splatfont2(.white, size: 16)
    }
    
    var ResultPlayer: some View {
        LazyVStack(content: {
            ForEach(result.player) { player in
                NavigationLink(destination: PlayerResultsView(player: player)) {
                    CoopPlayerView(player: player)
                        .padding(.bottom, 8)
                }
            }
        })
    }
}


