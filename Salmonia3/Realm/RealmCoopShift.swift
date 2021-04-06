//
//  RealmCoopShift.swift
//  Salmonia3
//
//  Created by Devonly on 3/14/21.
//

import Foundation
import RealmSwift

class RealmCoopShift: Object, Identifiable, Decodable {
    @objc dynamic var startTime: Int = 0
    @objc dynamic var endTime: Int = 0
    let stageId = RealmOptional<Int>()
    let rareWeapon = RealmOptional<Int>()
    dynamic var weaponList = List<Int>()

    override static func primaryKey() -> String? {
        return "startTime"
    }

    private enum CodingKeys: String, CodingKey {
        case startTime  = "start_time"
        case endTime    = "end_time"
        case stageId    = "stage_id"
        case rareWeapon = "rare_weapon"
        case weaponList = "weapon_list"
    }

//    override init() {}

    required convenience public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.startTime = try container.decode(Int.self, forKey: .startTime)
        self.endTime = try container.decode(Int.self, forKey: .endTime)
        self.stageId.value = try container.decode(Int.self, forKey: .stageId)
        self.rareWeapon.value = try container.decode(Int.self, forKey: .rareWeapon)
        let weaponList = try container.decodeIfPresent([Int].self, forKey: .weaponList) ?? [Int()]
        self.weaponList.append(objectsIn: weaponList)
    }
}
