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
            HStack(alignment: .center, spacing: nil, content: {
                VStack(alignment: .trailing, spacing: 4, content: {
                    ResultEgg(goldenIkuraNum: player.goldenIkuraNum, ikuraNum: player.ikuraNum)
                    ResultStatus(deadCount: player.deadCount, helpCount: player.helpCount)
                })
            })
        }
    }
}
