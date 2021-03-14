//
//  RealmCoopShift.swift
//  Salmonia3
//
//  Created by Devonly on 3/14/21.
//

import Foundation
import RealmSwift

class RealmCoopShift: Object, Decodable, Identifiable {
    @objc dynamic var startTime: String?
    @objc dynamic var endTime: String?
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
    
    override init() {}
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        
        let _startTime = try container.decode(Double.self, forKey: .startTime)
        startTime = dateFormatter.string(from: Date(timeIntervalSince1970: _startTime))
        let _endTime = try container.decode(Double.self, forKey: .endTime)
        endTime = dateFormatter.string(from: Date(timeIntervalSince1970: _endTime))
        stageId.value = try container.decode(Int.self, forKey: .stageId)
        rareWeapon.value = try container.decode(Int.self, forKey: .rareWeapon)
        let _weaponList = try container.decodeIfPresent([Int].self, forKey: .weaponList) ?? [Int()]
        weaponList.append(objectsIn: _weaponList)
    }
}
