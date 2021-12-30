//
//  ResultStats.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/30.
//

import SwiftUI

struct ResultStats: View {
    let player: RealmCoopPlayer
    
    var body: some View {
        VStack(alignment: .trailing, spacing: nil, content: {
            Text("RESULT.MATCHING.NUM.\(player.matchingCount)")
                .font(systemName: .Splatfont2, size: 14)
        })
    }
}

//struct ResultStats_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultStats()
//    }
//}
