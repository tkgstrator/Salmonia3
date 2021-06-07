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
    @objc dynamic var startTime: Int = 0
    @objc dynamic var endTime: Int = 0
    let stageId = RealmOptional<Int>()
    let rareWeapon = RealmOptional<Int>()
    dynamic var weaponList = List<Int>()

    override static func primaryKey() -> String? {
        return "startTime"
    }

    convenience init(from response: Response.ScheduleCoop) {
        self.init()
        self.startTime = response.startTime
        self.endTime = response.endTime
        self.stageId.value = response.stageId
        if response.weaponList.contains(-1) {
            self.rareWeapon.value = response.rareWeapon
        }
        self.weaponList.append(objectsIn: response.weaponList)
    }
}
