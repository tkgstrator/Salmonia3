//
//  WaveView.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/27.
//

import SwiftUI
import RealmSwift
import SplatNet2

struct WaveView: View {
    let wave: RealmCoopWave
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 45)), count: 4), content: {
            if let weaponList = wave.weaponList {
                ForEach(weaponList) { weapon in
                    Image(weapon)
                        .resizable()
                        .scaledToFit()
                }
            }
        })
    }
}

fileprivate extension RealmCoopWave {
    var weaponList: RealmSwift.List<WeaponType>? {
        guard let realm = try? Realm() else {
            return nil
        }
        return realm.objects(RealmCoopShift.self).first(where: { $0.startTime == result.startTime })?.weaponList
    }
}

//struct WaveView_Previews: PreviewProvider {
//    static var previews: some View {
//        WaveView()
//    }
//}
