//
//  ResultWeapon.swift.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/30.
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
        LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 20, maximum: 28), spacing: 2), count: weaponList.count + 1), alignment: .center, spacing: 0, content: {
            ForEach(weaponList.indices, id: \.self) { index in
                let weapon = weaponList[index]
                Image(weapon)
                    .resizable()
                    .scaledToFit()
                    .padding(2)
                    .background(Circle().fill(Color.black.opacity(0.9)))
            }
            Image(specialWeapon)
                .resizable()
                .scaledToFit()
                .padding(2)
                .background(Circle().fill(Color.black.opacity(0.9)))
        })
    }
}

struct ResultWeapon_Previews: PreviewProvider {
    static var weaponList: [WeaponType] = [.chargerLong, .chargerLight, .chargerKeeper]
    static var previews: some View {
        ResultWeapon(weaponList: weaponList, specialWeapon: .inkjet)
            .previewLayout(.fixed(width: 400, height: 120))
    }
}
