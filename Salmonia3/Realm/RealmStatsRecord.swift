//
//  RealmCoopStats.swift
//  Salmonia3
//
//  Created by tkgstrator on 3/23/21.
//

import Foundation
import RealmSwift
import Realm
import CryptoKit

class RealmStatsRecord: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var salmonId: Int
    @Persisted var goldenEggs: Int
    @Persisted var powerEggs: Int
    @Persisted var members: List<String>
    @Persisted var eventType: EventType?
    @Persisted var waterLevel: WaterLevel?
    @Persisted var recordType: RecordType
    @Persisted var recordTypeEgg: RecordTypeEgg
    @Persisted(originProperty: "records") var shift: LinkingObjects<RealmCoopShift>
    
    convenience init?(from response: StatsRecord.Records.Record.RecordDetail, startTime: Int, recordType: RecordType, recordTypeEgg: RecordTypeEgg) {
        guard let salmonId = response.id else { return nil }
        guard let powerEggs = response.powerEggs else { return nil }
        guard let goldenEggs = response.goldenEggs else { return nil }
        guard let members = response.members else { return nil }
        
        self.init()
        self.salmonId = salmonId
        self.goldenEggs = goldenEggs
        self.powerEggs = powerEggs
        self.members.append(objectsIn: members)
        if let eventType = response.eventType {
            self.eventType = EventType(rawValue: eventType)
        }
        if let waterLevel = response.waterLevel {
            self.waterLevel = WaterLevel(rawValue: waterLevel)
        }
        self.recordType = recordType
        self.recordTypeEgg = recordTypeEgg
        let platinText: String = [eventType?.rawValue, waterLevel?.rawValue, recordType.rawValue, recordTypeEgg.rawValue, startTime].compactMap({ String($0 ?? 0) }).joined()
        self.id = SHA256.hash(data: platinText.data(using: .utf8)!).compactMap { String(format: "%02X", $0) }.joined()
    }

    struct StatsRecord: Codable {
        let stageId: StageType
        let startTime: Int
        let endTime: Int
        let weaponList: [Int]
        let rareWeapon: Int?
        let records: Records
        
        struct Records: Codable {
            let goldenEggs: Record
            let powerEggs: Record
            
            struct Record: Codable {
                let total: RecordDetail
                let noNightEvent: RecordDetail
                let waves: [RecordDetail]
                
                struct RecordDetail: Codable {
                    let id: Int?
                    let goldenEggs: Int?
                    let powerEggs: Int?
                    let members: [String]?
                    let waterLevel: Int?
                    let eventType: Int?
                }
            }
        }
    }
    
    var stage: StageType {
        guard let stageId = self.shift.first?.stageId, let stage = StageType(rawValue: stageId) else { return .shakeup }
        return stage
    }
    
    var weaponList: [Int] {
        guard let weaponList = self.shift.first?.weaponList else { return [0, 0, 0, 0] }
        return Array(weaponList)
    }
    
    var wave: RealmCoopWave {
        RealmCoopWave(from: self)
    }
}
