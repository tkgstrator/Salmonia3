//
//  RealmCoopWave.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/12.
//

import Foundation
import RealmSwift

class RealmCoopWave: Object {
    @objc dynamic var event_type: String?
    @objc dynamic var water_level: String?
    @objc dynamic var golden_ikura_num: Int = 0
    @objc dynamic var golden_ikura_pop_num: Int = 0
    @objc dynamic var quota_num: Int = 0
    @objc dynamic var ikura_num: Int = 0
    let result = LinkingObjects(fromType: RealmCoopResult.self, property: "wave")
    
    override static func indexedProperties() -> [String] {
        return ["golden_ikura_num"]
    }
}
