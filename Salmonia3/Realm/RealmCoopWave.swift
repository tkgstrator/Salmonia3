//
//  RealmCoopWave.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/12.
//

import Foundation
import RealmSwift
import SalmonStats

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

    convenience init(from result: SalmonStats.ResultCoop.ResultWave) {
        self.init()
        self.eventType = SplatNet2Metadata.EventType(rawValue: result.eventType)!.eventType
        self.waterLevel = SplatNet2Metadata.WaterLevel(rawValue: result.waterLevel)!.waterLevel
        self.goldenIkuraNum = result.goldenIkuraNum
        self.goldenIkuraPopNum = result.goldenIkuraPopNum
        self.quotaNum = result.quotaNum
        self.ikuraNum = result.ikuraNum
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let event = try container.decode(EventType.self, forKey: .eventType)
        eventType = event.key

        let tide = try container.decode(WaterLevel.self, forKey: .waterLevel)
        waterLevel = tide.key

        goldenIkuraNum = try container.decode(Int.self, forKey: .goldenIkuraNum)
        goldenIkuraPopNum = try container.decode(Int.self, forKey: .goldenIkuraPopNum)
        quotaNum = try container.decode(Int.self, forKey: .quotaNum)
        ikuraNum = try container.decode(Int.self, forKey: .ikuraNum)
    }
}

fileprivate final class SplatNet2Metadata {
    enum EventType: Int {
        case noevent = 0
        case rush = 1
        case goldie = 2
        case griller = 3
        case mothership = 4
        case fog = 5
        case cohock = 6
    }
    
    enum WaterLevel: Int {
        case low = 0
        case normal = 1
        case high = 2
    }
}

fileprivate extension SplatNet2Metadata.EventType {
    var eventType: String {
        switch self {
        case .noevent:
            return "water-levels"
        case .rush:
            return "rush"
        case .goldie:
            return "goldie-seeking"
        case .griller:
            return "griller"
        case .mothership:
            return "the-mothership"
        case .fog:
            return "fog"
        case .cohock:
            return "cohock-charge"
        }
    }
}

fileprivate extension SplatNet2Metadata.WaterLevel {
    var waterLevel: String {
        switch self {
        case .low:
            return "low"
        case .normal:
            return "normal"
        case .high:
            return "high"
        }
    }
    
}

private class EventType: Codable {
    var key: String = ""
    var name: String = ""
}

private class WaterLevel: Codable {
    var key: String = ""
    var name: String = ""
}

extension RealmCoopWave: Identifiable {
    public var id: String { UUID().uuidString }
}
