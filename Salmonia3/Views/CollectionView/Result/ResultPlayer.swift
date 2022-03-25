//
//  ResultPlayerView.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/30.
//

import SwiftUI
import SwiftyUI
import RealmSwift

struct ResultPlayers: View {
    let result: RealmCoopResult
    
    var body: some View {
        ForEach(result.player) { player in
            ResultPlayer(player: player)
                .padding(.horizontal)
        }
    }
}

struct ResultPlayer: View {
    let player: RealmCoopPlayer
    
    var body: some View {
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.width / 356
            ZStack(alignment: .bottom, content: {
                Salmon()
                    .fill(Color.orange)
                    .aspectRatio(356/99.5, contentMode: .fit)
                HStack(alignment: .bottom, spacing: 0, content: {
                    VStack(alignment: .center, spacing: 0, content: {
                        Text(player.name ?? "-")
                            .font(systemName: .Splatfont2, size: 17 * scale, foregroundColor: .white)
                            .shadow(color: .black, radius: 0, x: 1, y: 1)
                            .frame(height: 18)
                        ResultWeapon(weaponList: player.weaponList, specialWeapon: player.specialId)
                        ResultDefeat(bossKillCount: player.bossKillCounts)
                    })
                    .background(Color.blue.opacity(0.3))
                    .padding(.leading, 12)
                    VStack(alignment: .trailing, spacing: 4, content: {
                        ResultEgg(goldenIkuraNum: player.goldenIkuraNum, ikuraNum: player.ikuraNum)
                        ResultStatus(deadCount: player.deadCount, helpCount: player.helpCount)
                    })
                    .background(Color.red.opacity(0.3))
                    .padding(.trailing, 12)
                })
                .padding(.bottom, 4)
            })
        })
        .aspectRatio(356/99.5, contentMode: .fit)
    }
}

struct iPhoneSE_Previews: PreviewProvider {
    static var previews: some View {
        ResultPlayer(player: RealmCoopPlayer(dummy: true))
            .previewLayout(.fixed(width: 320, height: 120 * 320 / 400))
    }
}

struct iPhone13Mini_Previews: PreviewProvider {
    static var previews: some View {
        ResultPlayer(player: RealmCoopPlayer(dummy: true))
            .previewLayout(.fixed(width: 356, height: 99.5))
    }
}

struct iPhonePlayers_Previews: PreviewProvider {
    static var previews: some View {
        ResultPlayers(result: RealmCoopResult(dummy: true))
    }
}
