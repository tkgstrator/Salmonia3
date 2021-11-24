//
//  RealmCoopShift.swift
//  Salmonia3
//
//  Created by devonly on 2021/11/24.
//  
//

import Foundation
import RealmSwift
import SplatNet2

final class RealmCoopShift: Object {
    @Persisted var stageId: Schedule.StageId
    @Persisted(primaryKey: true) var startTime: Int
    @Persisted var endTime: Int
    @Persisted var weaponList: List<WeaponType>
    @Persisted var rareWeapon: WeaponType?
    
    convenience init(from schedule: Schedule.Response) {
        self.init()
        self.stageId = schedule.stageId
        self.startTime = schedule.startTime
        self.endTime = schedule.endTime
        self.weaponList.append(objectsIn: schedule.weaponList)
        self.rareWeapon = schedule.rareWeapon
    }
}

extension RealmCoopShift: Identifiable {
    var id: Int { startTime }
}

extension WeaponType: PersistableEnum {
}

extension Schedule.StageId: PersistableEnum {
}
