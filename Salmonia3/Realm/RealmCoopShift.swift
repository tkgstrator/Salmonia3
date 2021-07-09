//
//  RealmCoopShift.swift
//  Salmonia3
//
//  Created by Devonly on 3/14/21.
//

import Foundation
import RealmSwift
import SplatNet2

final class RealmCoopShift: Object, Identifiable {
    
    @Persisted(primaryKey: true) var startTime: Int
    @Persisted var endTime: Int
    @Persisted var stageId: Int
    @Persisted var rareWeapon: Int?
    @Persisted var weaponList: List<Int>

    convenience init(from response: Response.ScheduleCoop) {
        self.init()
        self.startTime = response.startTime
        self.endTime = response.endTime
        self.stageId = response.stageId
        if response.weaponList.contains(-1) {
            self.rareWeapon = response.rareWeapon
        }
        self.weaponList.append(objectsIn: response.weaponList)
    }
}
