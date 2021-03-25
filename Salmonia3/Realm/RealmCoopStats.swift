//
//  RealmCoopStats.swift
//  Salmonia3
//
//  Created by Devonly on 3/23/21.
//

import Foundation
import RealmSwift
import Realm

struct RealmCoopStats {
    
    public var jobNum: Int?
    public var schedule: String?
    public var clearRatio: Double?
    public var totalPowerEggs: Int?
    public var totalGoldenEggs: Int?
    public var ratePowerEggs: Double?
    public var rateGoldenEggs: Double?
    public var maxResult: MaxResult = MaxResult()
    public var avgResult: AvgResult = AvgResult()

    init(startTime: String) { [self]
        guard let realm = try? Realm() else { return }
        guard let pid = realm.objects(RealmUserInfo.self).first?.nsaid else { return }
        let results = realm.objects(RealmCoopResult.self).filter("startTime=%@", startTime)
        guard let _ = results.first else { return }
        let player = realm.objects(RealmPlayerResult.self).filter("ANY result.startTime=%@ AND pid=%@", startTime, pid)
        print(player.count)
        
        maxResult.goldenEggs = results.max(ofProperty: "goldenEggs")
        maxResult.powerEggs = results.max(ofProperty: "powerEggs")
        maxResult.gradePoint = results.max(ofProperty: "gradePoint")
        avgResult.goldenEggs = results.average(ofProperty: "goldenEggs")
        avgResult.powerEggs = results.average(ofProperty: "powerEggs")
        
    }
    
    init() {}
}

class MaxResult {
    public var gradePoint: Int?
    public var teamPowerEggs: Int?
    public var teamGoldenEggs: Int?
    public var goldenEggs: Int?
    public var powerEggs: Int?
    public var defeated: Int?
    public var help: Int?
    public var dead: Int?
}

class AvgResult {
    public var teamPowerEggs: Double?
    public var teamGoldenEggs: Double?
    public var goldenEggs: Double?
    public var powerEggs: Double?
    public var defeated: Double?
    public var help: Double?
    public var dead: Double?
}
