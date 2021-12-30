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
    let weaponList: RealmSwift.List<Int>
    let specialWeapon: SpecialId
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 20, maximum: 30)), count: weaponList.count), alignment: .leading, content: {
            
        })
    }
}

//struct ResultWeapon_swift_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultWeapon(weaponList: <#T##RealmSwift.List<Int>#>, specialWeapon: <#T##SpecialId#>, body: <#T##View#>)
//    }
//}
