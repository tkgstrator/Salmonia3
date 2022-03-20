//
//  RankShiftStats.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/06.
//

import Foundation
import RealmSwift
import SplatNet2

final class RankShiftStats: ObservableObject {
    internal let realm: Realm
    internal let nsaid: String?
    internal let schemeVersion: UInt64 = 8192
    
    internal var goldenEggs: [RankEgg] = []
    
    init(startTime: Int, nsaid: String?) {
        do {
            self.realm = try Realm()
            self.nsaid = nsaid
        } catch {
            var config = Realm.Configuration.defaultConfiguration
            config.deleteRealmIfMigrationNeeded = true
            config.schemaVersion = schemeVersion
            self.realm = try! Realm(configuration: config, queue: nil)
            self.nsaid = nsaid
        }
        
        // nsaidがオプショナルなら何もしない
        guard let nsaid = nsaid else {
            return
        }
        
//        for eventType in EventKey.allCases {
//            for waterLevel in WaterKey.allCases {
//                let results = realm.objects(RealmStatsWave.self).filter("eventType=%@ AND waterLevel=%@ AND ANY link.startTime=%@", eventType, waterLevel, startTime)
//                let goldenEgg = results.filter({ $0.members.contains(nsaid) }).map({ $0.goldenIkuraNum }).max()
//                let goldenEggs = results.map({ $0.goldenIkuraNum }).sorted(by: { $1 < $0 })
//                let rank: Int? = {
//                    guard let goldenEgg = goldenEgg else {
//                        return nil
//                    }
//                    if let firstIndex = goldenEggs.firstIndex(of: goldenEgg) {
//                        return firstIndex + 1
//                    }
//                    return nil
//                }()
//                let count: Int? = {
//                    switch (waterLevel, eventType) {
//                    case (WaterKey.high, EventKey.cohockCharge),
//                        (WaterKey.normal, EventKey.cohockCharge),
//                        (WaterKey.low, EventKey.rush),
//                        (WaterKey.low, EventKey.goldieSeeking),
//                        (WaterKey.low, EventKey.griller):
//                        return nil
//                    default:
//                        return results.count
//                    }
//                }()
//                self.goldenEggs.append(RankEgg(goldenEggs: goldenEgg, rank: rank, total: count, eventType: eventType, waterLevel: waterLevel))
//            }
//        }
    }
}


internal struct RankEgg: Identifiable {
    let goldenEggs: Int?
    let rank: Int?
    let total: Int?
    let eventType: EventKey
    let waterLevel: WaterKey
    var id: String {
        eventType.rawValue + waterLevel.rawValue
    }
}
