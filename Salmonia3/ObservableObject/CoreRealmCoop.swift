//
//  CoreRealmCoop.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/12.
//

import Foundation
import RealmSwift
import Combine
import SwiftUI
import SplatNet2

class CoreRealmCoop: ObservableObject {
    @ObservedObject var appManager: AppManager = AppManager()
    @Published var resultCount: Int = RealmManager.Objects.results.count
    @Published var waves: RealmSwift.Results<RealmCoopWave> = RealmManager.Objects.waves
    @Published var players: RealmSwift.Results<RealmPlayer> = RealmManager.Objects.players
    @Published var result: [RealmCoopResult] = Array(RealmManager.Objects.results.prefix(5))
    var results: [UserCoopResult] {
        let startTime: [Int] = Array(Set(RealmManager.Objects.results.map({ $0.startTime }))).sorted(by: <)
        return startTime.map({ UserCoopResult(startTime: $0) })
    }
    
    var records: [CoopRecord] {
        return Range(5000 ... 5004).map{ CoopRecord(stageId: $0) }
    }
    
    init() {
        
    }
    
    deinit {
    }
}

// MARK: リザルト一覧で使うデータ
class UserCoopResult: Identifiable {
    var id: UUID = UUID()
    var phase: RealmCoopShift
    var results: RealmSwift.Results<RealmCoopResult>
        
    init(startTime: Int) {
        self.phase = RealmManager.Objects.shift(startTime: startTime)
        results = RealmManager.Objects.results(startTime: startTime)
    }

    init(startTime: Int, playerId: String) {
        self.phase = RealmManager.Objects.shift(startTime: startTime)
        results = RealmManager.Objects.results(startTime: startTime, playerId: playerId)
    }
}


// MARK: ステージキロク
class CoopRecord: ObservableObject {
    var jobNum: Int?
    var maxGrade: Int?
    var goldenEggs: [[GoldenEggsRecord?]] = Array(repeating: Array(repeating: nil, count: 7), count: 3)

    init() {}
    
    init(startTime: Int) {
        let results = RealmManager.Objects.results(startTime: startTime)
        let waves = RealmManager.Objects.waves(startTime: startTime)
        
        getRecordsFromDatabase(results: results, waves: waves)
    }
    
    init(stageId: Int) {
        let results = RealmManager.Objects.results(stageId: stageId)
        let waves = RealmManager.Objects.waves(stageId: stageId)
        getRecordsFromDatabase(results: results, waves: waves)
    }
    
    func getRecordsFromDatabase(results: RealmSwift.Results<RealmCoopResult>, waves: RealmSwift.Results<RealmCoopWave>) {
        if results.count != 0 {
            self.jobNum = results.count
            self.maxGrade = results.max(ofProperty: "gradePoint")
            
            // MARK: WAVE納品キロク
            for tide in WaterLevel.allCases {
                for event in EventType.allCases {
                    if let goldenEgg: Int = waves.filter("eventType=%@ AND waterLevel=%@", event.eventType, tide.waterLevel).max(ofProperty: "goldenIkuraNum") {
                        self.goldenEggs[tide.rawValue][event.rawValue] = GoldenEggsRecord(goldenEggs: goldenEgg, playTime: nil, tide: tide.rawValue, event: event.rawValue)
                    }
                }
            }
        }
    }
}

struct GoldenEggsRecord {
    var goldenEggs: Int?
    var playTime: Int?
    var tide: Int
    var event: Int
}
