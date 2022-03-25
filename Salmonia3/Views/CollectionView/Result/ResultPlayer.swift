//
//  ResultPlayerView.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/30.
//

import SwiftUI
import SwiftyUI
import RealmSwift

struct ResultPlayer: View {
    let result: RealmCoopResult
    
    var body: some View {
        ForEach(result.player) { player in
            ZStack(alignment: .bottom, content: {
                Salmon()
                    .fill(Color.orange)
                    .aspectRatio(365/99.5, contentMode: .fit)
                VStack(content: {
                    HStack(alignment: .bottom, spacing: nil, content: {
                        VStack(alignment: .center, spacing: -4, content: {
                            Text(player.name ?? "-")
                                .padding(.bottom, 4)
                                .font(systemName: .Splatfont2, size: 17, foregroundColor: .white)
                                .shadow(color: .black, radius: 0, x: 1.2, y: 0.5)
                            ResultWeapon(weaponList: player.weaponList, specialWeapon: player.specialId)
                            ResultDefeat(bossKillCount: player.bossKillCounts)
                        })
                        VStack(alignment: .trailing, spacing: 4, content: {
                            ResultEgg(goldenIkuraNum: player.goldenIkuraNum, ikuraNum: player.ikuraNum)
                            ResultStatus(deadCount: player.deadCount, helpCount: player.helpCount)
                        })
                    })
                })
                .padding(.bottom, 3)
                .padding(.trailing, 14)
            })
            .padding(.horizontal, 4)
        }
    }
}

struct ResultPlayer_Previews: PreviewProvider {
    static var previews: some View {
        ResultPlayer(result: RealmCoopResult(dummy: true))
            .previewLayout(.fixed(width: 400, height: 120))
    }
}
