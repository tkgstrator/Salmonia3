//
//  ResultWeapon.swift.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/30.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet2
import RealmSwift

struct ResultWeapon: View {
    let weaponList: [WeaponType]
    let specialWeapon: SpecialId
    
    init(weaponList: [WeaponType], specialWeapon: SpecialId) {
        self.weaponList = weaponList
        self.specialWeapon = specialWeapon
    }
    
    init(weaponList: RealmSwift.List<WeaponType>, specialWeapon: SpecialId) {
        self.weaponList = Array(weaponList)
        self.specialWeapon = specialWeapon
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.width / 172
            LazyVGrid(columns: Array(repeating: .init(.fixed(28 * scale), spacing: 2), count: 6), alignment: .center, spacing: 0, content: {
                Image(.randomGreen)
                    .resizable()
                    .scaledToFit()
                    .padding(2 * scale)
                    .background(Circle().fill(Color.black.opacity(0.9)))
                    .hidden()
                ForEach(weaponList.indices, id: \.self) { index in
                    let weapon = weaponList[index]
                    Image(weapon)
                        .resizable()
                        .scaledToFit()
                        .padding(2 * scale)
                        .background(Circle().fill(Color.black.opacity(0.9)))
                }
                Image(specialWeapon)
                    .resizable()
                    .scaledToFit()
                    .padding(2 * scale)
                    .background(Circle().fill(Color.black.opacity(0.9)))
                Image(.randomGreen)
                    .resizable()
                    .scaledToFit()
                    .padding(2 * scale)
                    .background(Circle().fill(Color.black.opacity(0.9)))
                    .hidden()
            })
            .position(geometry.center)
        })
        .aspectRatio(172/40, contentMode: .fit)
    }
}

struct ResultWeapon_Previews: PreviewProvider {
    static var weaponList: [WeaponType] = [.chargerLong, .chargerLight, .chargerKeeper]
    static var previews: some View {
        ResultWeapon(weaponList: weaponList, specialWeapon: .inkjet)
            .previewLayout(.fixed(width: 200, height: 30))
        ResultWeapon(weaponList: weaponList, specialWeapon: .inkjet)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
