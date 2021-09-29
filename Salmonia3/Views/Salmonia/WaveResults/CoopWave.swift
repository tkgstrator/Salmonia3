//
//  CoopWave.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/29.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import Foundation

class CoopWave {
    let stage: StageType
    let waterLevel: WaterLevel?
    let eventType: EventType?
    let goldenIkuraNum: Int
    let ikuraNum: Int
    let weaponList: [Int]
    let recordType: RecordType?
    let recordTypeEgg: RecordTypeEgg?
    
    init() {
        self.stage = .shakeup
        self.waterLevel = nil
        self.eventType = nil
        self.goldenIkuraNum = 0
        self.ikuraNum = 0
        self.weaponList = [0, 0, 0, 0]
        self.recordType = nil
        self.recordTypeEgg = nil
    }
    
    init(from wave: RealmCoopWave) {
        self.stage = wave.stage
        self.waterLevel = wave.waterLevel
        self.eventType = wave.eventType
        self.goldenIkuraNum = wave.goldenIkuraNum
        self.ikuraNum = wave.ikuraNum
        self.weaponList = wave.weaponList
        self.recordType = nil
        self.recordTypeEgg = nil
    }
    
    init(from record: RealmStatsRecord) {
        self.stage = record.stage
        self.waterLevel = record.waterLevel
        self.eventType = record.eventType
        self.goldenIkuraNum = record.goldenEggs
        self.ikuraNum = record.powerEggs
        self.weaponList = record.weaponList
        self.recordType = record.recordType
        self.recordTypeEgg = record.recordTypeEgg
    }
}
