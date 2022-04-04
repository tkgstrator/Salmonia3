//
//  WeaponColletionView.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/06.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet2

struct WeaponCollectionView: View {
    @StateObject var stats: WeaponShiftStats
    
    init(shift: RealmCoopShift, nsaid: String?) {
        self._stats = StateObject(wrappedValue: WeaponShiftStats(schedule: shift, nsaid: nsaid))
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 1), content: {
                Section(content: {
                    WeaponOverview(stats: stats)
                }, header: {
                    Text("概要")
                        .font(systemName: .Splatfont2, size: 14)
                })
            })
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), content: {
                Section(content: {
                    ForEach(stats.suppliedWeaponList) { weapon in
                        StatsWeaponDetail(weaponData: weapon)
                    }
                }, header: {
                    Text("支給済みブキ")
                        .font(systemName: .Splatfont2, size: 14)
                })
                Section(content: {
                    ForEach(stats.unSuppliedWeaponList) { weapon in
                        StatsWeaponDetail(weaponData: weapon)
                    }
                }, header: {
                    Text("未支給ブキ")
                        .font(systemName: .Splatfont2, size: 14)
                })
            })
        })
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("ランダムブキ一覧")
    }
}

fileprivate extension RealmCoopShift {
    var suppliableWeaponList: [WeaponType] {
        let weaponList: [WeaponType] = WeaponType.allCases.filter({ $0.id >= 0 && $0.id < 20000 })
        if let rareWeapon = rareWeapon {
            return weaponList + [rareWeapon]
        }
        return weaponList
    }
}

//struct WeaponCollectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeaponCollectionView()
//    }
//}
