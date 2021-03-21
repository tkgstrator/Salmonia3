//
//  CoopResult.swift
//  Salmonia3
//
//  Created by Devonly on 3/19/21.
//

import SwiftUI

struct CoopResultView: View {
    var result: RealmCoopResult
    @State var isAnonymous: Bool = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ResultOverview
                ResultWave
                ResultPlayer
            }
        }
        .padding(.bottom, 50)
        .backgroundColor(.black)
        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarItems(trailing: SRButton)
        .navigationTitle("TITLE_RESULT_DETAIL")
    }
    
    var SRButton: some View {
        HStack {
            Button(action: { isAnonymous.toggle() }) { Image(systemName: "person.circle.fill") }
            //            Button(action: { isEnable.toggle() }) { Image(systemName: "info.circle.fill") }
        }
    }
    
    #warning("直接画像返すやつ書けばよくね？？？")
    var ResultOverview: some View {
        ZStack(alignment: .center) {
            Image(StageType(rawValue: result.stageId.intValue)!.md5)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 8.0))
                .frame(height: 120)
                .mask(Image("2ce11ebf110993621bedd8e747d7b1b").resizable())
            VStack(spacing: 0) {
                // プレイ時間の表示
                Text(result.playTime.stringValue)
                    .splatfont2(.white, size: 22)
                // キケン度の表示
                DangerRate
                // イクラ数の表示
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
//            .padding(.vertical, 20)
        }
        .splatfont2(.white, size: 20)
    }
    
    var ResultWave: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 140)), count: result.wave.count)) {
            ForEach(result.wave.indices, id:\.self) { index in
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
                }
            }
//            .id(UUID())
        }
        .frame(height: 180)
        .splatfont2(size: 16)
        .padding(.horizontal, 5)
    }
    
    var ResultPlayer: some View {
        LazyHGrid(rows: Array(repeating: .init(.flexible(minimum: 80)), count: result.player.count), spacing: 0) {
            ForEach(result.player.indices, id:\.self) { index in
                PlayerView(player: result.player[index])
//                    .id(UUID())
            }
        }
    }
    
    
    var DangerRate: some View {
        switch result.dangerRate.value! == 200 {
        case true:
            return Text("RESULT_HAZARD_LEVEL_MAX")
                .splatfont2(.yellow, size: 20)
        case false:
            return Text("RESULT_HAZARD_LEVEL_\(String(result.dangerRate.value!))")
                .splatfont2(.yellow, size: 20)
        }
        
    }
}

struct PlayerView: View {
    var player: RealmPlayerResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom) {
                VStack(spacing: 3) {
                    Text(player.name.stringValue)
                        .splatfont2(.white, size: 18)
                        .frame(height: 10)
                    HStack {
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: player.weaponList.count + 1), alignment: .leading, spacing: 0, pinnedViews: []) {
                            SRImage(from: SRImage.ImageType(rawValue: player.specialId)!, size: CGSize(width: 25, height: 25))
                            ForEach(player.weaponList.indices, id:\.self) { index in
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

//struct CoopResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        CoopResultView()
//    }
//}
