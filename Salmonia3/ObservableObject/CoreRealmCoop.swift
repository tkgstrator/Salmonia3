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
    private var token: NotificationToken?
    @Published var resultCount: Int = RealmManager.Objects.results.count
    @Published var waves: RealmSwift.Results<RealmCoopWave> = RealmManager.Objects.waves
    @Published var players: RealmSwift.Results<RealmPlayer> = RealmManager.Objects.players
    @Published var result: [RealmCoopResult] = Array(RealmManager.Objects.results.prefix(5))
    @Published var latestShift: RealmSwift.Results<RealmCoopShift> = RealmManager.latestShiftStartTime
    
    // リザルト一覧
    var results: [UserCoopResult] {
        let startTime: [Int] = Array(Set(RealmManager.Objects.results.map({ $0.startTime }))).sorted(by: >)
        return startTime.map({ UserCoopResult(startTime: $0) })
    }
    
    // ステージ記録一覧
    var records: [CoopRecord] {
        return StageType.allCases.map{ CoopRecord(stageId: $0.rawValue) }
    }
    
    init() {
        // 不要だとは思うが念の為にアップデートする
        token = RealmManager.Objects.results.observe { [weak self] _ in
            self?.objectWillChange.send()
        }
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
        self.results = RealmManager.Objects.results(startTime: startTime)
    }

    init(startTime: Int, playerId: String) {
        self.phase = RealmManager.Objects.shift(startTime: startTime)
        self.results = RealmManager.Objects.results(startTime: startTime, memberId: playerId)
    }
}

// MARK: ステージキロク
class CoopRecord: ObservableObject {
    var jobNum: Int?
    var maxGrade: Int?
    var counterStepNum: Int = 0
    var minimumStepNum: Int?
    var goldenEggs: [[GoldenEggsRecord?]] = Array(repeating: Array(repeating: nil, count: 7), count: 3)
    var maxGoldenEggs: (all: Int?, nonight: Int?) = (all: .none, nonight: .none)
    
    init() {}
   
    // シフトごとの記録
    init(startTime: Int) {
        let results = RealmManager.Objects.results(startTime: startTime)
        let waves = RealmManager.Objects.waves(startTime: startTime)
        getRecordsFromDatabase(results: results, waves: waves)
    }
    
    // ステージごとの記録
    init(stageId: Int) {
        let results = RealmManager.Objects.results(stageId: stageId)
        let waves = RealmManager.Objects.waves(stageId: stageId)
        getRecordsFromDatabase(results: results, waves: waves)
    }
    
    func getRecordsFromDatabase(results: RealmSwift.Results<RealmCoopResult>, waves: RealmSwift.Results<RealmCoopWave>) {
        if results.count != 0 {
            self.jobNum = results.count
            self.maxGrade = results.max(ofProperty: "gradePoint")
            self.counterStepNum = results.counterStepNum
            self.minimumStepNum = results.minimumStepNum
            
            // 最高納品数
            maxGoldenEggs = (all: results.max(ofProperty: "goldenEggs"),
                             nonight: results.filter("SUBQUERY(wave, $wave, $wave.eventType=%@).@count==3", "water-levels").max(ofProperty: "goldenEggs"))
            
            // MARK: WAVE納品キロク
            for waterLevel in WaterLevel.allCases {
                for eventType in EventType.allCases {
                    if let goldenEgg: Int = waves.maxGoldenEggs(eventType: eventType, waterLevel: waterLevel) {
                        self.goldenEggs[waterLevel.rawValue][eventType.rawValue] = GoldenEggsRecord(goldenEggs: goldenEgg)
                    }
                }
            }
        }
    }
}

struct GoldenEggsRecord {
    var goldenEggs: Int?
    var playTime: Int? = 0
    var tide: Int = 0
    var event: Int = 0
}
