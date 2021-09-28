//
//  RealmCoopStats.swift
//  Salmonia3
//
//  Created by tkgstrator on 3/23/21.
//

import Foundation
import RealmSwift
import Realm

class RealmStatsRecord: Object, ObjectKeyIdentifiable {
    @Persisted var id: Int
    @Persisted var goldenEggs: Int
    @Persisted var powerEggs: Int
    @Persisted var members: List<String>
    @Persisted var eventType: Int?
    @Persisted var waterLevel: Int?
    @Persisted var recordType: Int?
    
    convenience init?(from response: StatsRecord.Records.Record.RecordDetail) {
        guard let id = response.id else { return nil }
        guard let powerEggs = response.powerEggs else { return nil }
        guard let goldenEggs = response.goldenEggs else { return nil }
        guard let members = response.members else { return nil }
        self.init()
        self.id = id
        self.goldenEggs = goldenEggs
        self.powerEggs = powerEggs
        self.members.append(objectsIn: members)
        self.eventType = response.eventType
        self.waterLevel = response.waterLevel
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
}
