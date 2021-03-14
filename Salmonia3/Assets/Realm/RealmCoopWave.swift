//
//  RealmCoopWave.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/12.
//

import Foundation
import RealmSwift

class RealmCoopWave: Object, Decodable {
    @objc dynamic var eventType: String?
    @objc dynamic var waterLevel: String?
    @objc dynamic var goldenIkuraNum: Int = 0
    @objc dynamic var goldenIkuraPopNum: Int = 0
    @objc dynamic var quotaNum: Int = 0
    @objc dynamic var ikuraNum: Int = 0
    let result = LinkingObjects(fromType: RealmCoopResult.self, property: "wave")
    
    override static func indexedProperties() -> [String] {
        return ["golden_ikura_num"]
    }
    
    private enum CodingKeys: String, CodingKey {
        case eventType          = "event_type"
        case waterLevel         = "water_level"
        case goldenIkuraNum     = "golden_ikura_num"
        case goldenIkuraPopNum  = "golden_ikura_pop_num"
        case quotaNum           = "quota_num"
        case ikuraNum           = "ikura_num"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        eventType = try? container.decode(String.self, forKey: .eventType)
        waterLevel = try? container.decode(String.self, forKey: .waterLevel)
        goldenIkuraNum = try container.decode(Int.self, forKey: .goldenIkuraNum)
        goldenIkuraPopNum = try container.decode(Int.self, forKey: .goldenIkuraPopNum)
        quotaNum = try container.decode(Int.self, forKey: .quotaNum)
        ikuraNum = try container.decode(Int.self, forKey: .ikuraNum)
    }
}
