//
//  ResultUser.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/23.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet2
import RealmSwift

struct ResultUser: View {
//    let result: RealmCoopPlayer = {
//        let player = RealmCoopPlayer()
//        player.specialId = .splashdown
//        player.weaponList.append(objectsIn: [WeaponType.chargerSpark, WeaponType.slosherVase, WeaponType.shooterBlasterBurst])
//        return player
//    }()
    let result: RealmCoopPlayer
    
    var body: some View {
        Image(result.specialId)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 24)
//            .padding(4)
            .background(Circle().fill(Color.blackrussian.opacity(0.85)))
    }
}

//struct ResultUser_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultUser()
//    }
//}
