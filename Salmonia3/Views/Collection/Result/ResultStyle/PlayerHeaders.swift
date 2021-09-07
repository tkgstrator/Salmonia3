//
//  PlayerHeaders.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/07.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI
import RealmSwift
import URLImage

struct PlayerHeaders: View {
    let player: RealmSwift.List<RealmPlayerResult>
    let colors: [Color] = [.venitianred, .deepskyblue, .salam, .turbo]
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 60, maximum: 80)), count: 4), alignment: .center, spacing: 5, pinnedViews: [], content: {
            ForEach(player.indices, id:\.self) { index in
                VStack(alignment: .center, spacing: nil, content: {
                    URLImage(url: player[index].thumbnailURL, content: { thumbnailImage in
                        thumbnailImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .mask(Circle())
                    })
                    .overlay(Circle().stroke(colors[index], lineWidth: 6))
                    .padding(.horizontal, 4)
                })
            }
        })
        .padding()
    }
}

//struct PlayerHeaders_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayerHeaders()
//    }
//}
