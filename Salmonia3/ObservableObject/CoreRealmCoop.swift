//
//  CoreRealmCoop.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/03/12.
//

import Foundation
import RealmSwift
import Combine
import SwiftUI
import SplatNet2

class CoreRealmCoop: ObservableObject {
    private var token: NotificationToken?
    @Published var resultCount: Int = RealmManager.shared.results.count
    @Published var waves: RealmSwift.Results<RealmCoopWave> = RealmManager.shared.waves
    @Published var players: RealmSwift.Results<RealmPlayer> = RealmManager.shared.players
    @Published var latestShift: RealmSwift.Results<RealmCoopShift> = RealmManager.shared.latestShiftStartTime
    @Published var clearResults: UserOverview = UserOverview()
    @Published var records: UserCoopRecord = UserCoopRecord()
    
    /// リザルト一覧で表示するためのリザルト
    var results: [UserCoopResult] {
        let startTime: [Int] = Array(Set(RealmManager.shared.results.map({ $0.startTime }))).sorted(by: >)
        return startTime.map({ UserCoopResult(startTime: $0) })
    }
    
    /// どこで使っているのかわからない選択中のプレイヤーの全リザルト
    var result: RealmSwift.Results<RealmCoopResult> {
        RealmManager.shared.results(playerId: manager.playerId)
    }
    
    init() {
        // 不要だとは思うが念の為にアップデートする
        token = RealmManager.shared.results.observe { [weak self] _ in
            // これらはアップデートしないと更新されない
            self?.clearResults = UserOverview()
            self?.records = UserCoopRecord()
            self?.objectWillChange.send()
        }
    }
    
    deinit {
    }
}

class UserOverview: Identifiable {
    /// 全バイト回数(計算するのがめんどくさいので)
    var total: Int = 0
    /// 全バイトのクリア回数
    var clear: Int = 0
    /// 全バイトの失敗回数
    var failure: Result.FailureReason = Result.FailureReason()
    /// 各WAVEをクリアしたかどうか
    /// 各WAVEをクリアしたかどうか
    var waves: [Result] = Array(repeating: Result(), count: 3)
    /// 全潮位・イベント・WAVEでのクリア率
    var results: [[[Result]]] = Array(repeating: Array(repeating: Array(repeating: Result(), count: 3), count: 7), count: 5)
    
    init() {
        let results = RealmManager.shared.results
        self.total = results.count
        self.clear = results.filter("isClear==true").count
        self.waves = [1, 2, 3].map({ Result(success: results.filter("isClear==true OR failureWave > %@", $0).count,
                                        failure: (results.filter("isClear==false AND failureWave==%@ AND failureReason==%@", $0, "time_limit").count,
                                                  results.filter("isClear==false AND failureWave==%@ AND failureReason==%@", $0, "wipe_out").count)) })
        self.failure = Result.FailureReason(timeLimit: waves.map({ $0.failure.timeLimit }).reduce(0, +), wipeOut: waves.map({ $0.failure.wipeOut }).reduce(0, +))
    }
    
    struct Result: Identifiable, Hashable {
        static func == (lhs: UserOverview.Result, rhs: UserOverview.Result) -> Bool {
            lhs.id == rhs.id
        }
        var id: UUID = UUID()
        var success: Int = 0
        var failure: FailureReason = FailureReason()

        internal init() {}
        
        internal init(success: Int, failure: (Int, Int)) {
            self.success = success
            self.failure = FailureReason(timeLimit: failure.0, wipeOut: failure.1)
        }
        
        struct FailureReason: Hashable {
            var timeLimit: Int = 0
            var wipeOut: Int = 0
            
            internal init(timeLimit: Int = 0, wipeOut: Int = 0) {
                self.timeLimit = timeLimit
                self.wipeOut = wipeOut
            }
        }
    }
}

// MARK: リザルト一覧で使うデータ
class UserCoopResult: Identifiable {
    var id: UUID = UUID()
    var phase: RealmCoopShift
    var results: RealmSwift.Results<RealmCoopResult>
        
    init(startTime: Int) {
        self.phase = RealmManager.shared.shift(startTime: startTime)
        self.results = RealmManager.shared.results(startTime: startTime)
    }

    init(startTime: Int, playerId: String) {
        self.phase = RealmManager.shared.shift(startTime: startTime)
        self.results = RealmManager.shared.results(startTime: startTime, memberId: playerId)
    }
}

class UserCoopRecord: Identifiable {
    var id: UUID = UUID()
    var records: [Record] = []

    internal init() {
        
        for stageId in StageType.allCases {
            let waves = RealmManager.shared.allWaves(stageId: stageId.rawValue)
            let results = RealmManager.shared.allResults(stageId: stageId.rawValue)
            
            // 夜込み最高記録を計算
            let total = Array(results.sorted(byKeyPath: "goldenEggs", ascending: false).prefix(3)).map({ Record(stageId: stageId, playTime: $0.playTime, powerEggs: $0.powerEggs, goldenEggs: $0.goldenEggs, players: $0.players, weaponList: $0.weaponLists, recordType: .total) })
            records.append(contentsOf: total)

            // 昼のみ最高記録を計算
            let nonight = results.filter("SUBQUERY(wave, $wave, $wave.eventType=%@).@count==3", 0).sorted(byKeyPath: "goldenEggs", ascending: false).prefix(3).map({ Record(stageId: stageId, playTime: $0.playTime, powerEggs: $0.powerEggs, goldenEggs: $0.goldenEggs, players: $0.players, weaponList: $0.weaponLists, recordType: .nonight) })
            records.append(contentsOf: nonight)

            // 各イベント・潮位についてTOP3の記録を抽出
            for eventType in EventType.allCases {
                for waterLevel in WaterLevel.allCases {
                    let results = Array(waves.filter("eventType=%@ AND waterLevel=%@", eventType.rawValue, waterLevel.rawValue).sorted(byKeyPath: "goldenIkuraNum", ascending: false).prefix(3))
                    let record = results.map({ Record(stageId: stageId, playTime: $0.playTime, waterLevel: waterLevel, eventType: eventType, powerEggs: $0.ikuraNum, goldenEggs: $0.goldenIkuraNum, players: $0.players, weaponList: $0.weaponLists) })
                    records.append(contentsOf: record)
                }
            }
        }
    }
    
    class Record: Identifiable {
        var id: UUID = UUID()
        var playTime: Int
        var stageId: StageType
        var waterLevel: WaterLevel
        var eventType: EventType
        var goldenEggs: Int
        var powerEggs: Int
        var players: [RealmPlayer]
        var weaponList: [Int]
        var recordType: RecordType
        
        internal init(stageId: StageType, playTime: Int, waterLevel: WaterLevel = .middle, eventType: EventType = .noevent, powerEggs: Int, goldenEggs: Int, players: [RealmPlayer], weaponList: [Int], recordType: RecordType = .wave) {
            self.stageId = stageId
            self.waterLevel = waterLevel
            self.eventType = eventType
            self.powerEggs = powerEggs
            self.goldenEggs = goldenEggs
            self.players = players
            self.weaponList = weaponList
            self.recordType = recordType
            self.playTime = playTime
        }
        
        enum RecordType: CaseIterable {
            case wave
            case nonight
            case total
        }
    }
}
// MARK: ステージキロク
//#warning("将来的にこれ削除したい")
//class CoopRecord: ObservableObject {
//    var jobNum: Int?
//    var maxGrade: Int?
//    var counterStepNum: Int = 0
//    var minimumStepNum: Int?
//    var goldenEggs: [[GoldenEggsRecord?]] = Array(repeating: Array(repeating: nil, count: 7), count: 3)
//    var maxGoldenEggs: (all: Int?, nonight: Int?) = (all: .none, nonight: .none)
//
//    init() {}
//
//    // シフトごとの記録
//    init(startTime: Int) {
//        let results = RealmManager.shared.results(startTime: startTime)
//        let waves = RealmManager.shared.waves(startTime: startTime)
//        getRecordsFromDatabase(results: results, waves: waves)
//    }
//
//    // ステージごとの記録
//    init(stageId: Int) {
//        let results = RealmManager.shared.results(stageId: stageId)
//        let waves = RealmManager.shared.waves(stageId: stageId)
//        getRecordsFromDatabase(results: results, waves: waves)
//    }
//
//    func getRecordsFromDatabase(results: RealmSwift.Results<RealmCoopResult>, waves: RealmSwift.Results<RealmCoopWave>) {
//        if results.count != 0 {
//            self.jobNum = results.count
//            self.maxGrade = results.max(ofProperty: "gradePoint")
//            self.counterStepNum = results.counterStepNum
//            self.minimumStepNum = results.minimumStepNum
//
//            // 最高納品数
//            maxGoldenEggs = (all: results.max(ofProperty: "goldenEggs"),
//                             nonight: results.filter("SUBQUERY(wave, $wave, $wave.eventType=%@).@count==3", "water-levels").max(ofProperty: "goldenEggs"))
//
//            // MARK: WAVE納品キロク
//            for waterLevel in WaterLevel.allCases {
//                for eventType in EventType.allCases {
//                    if let goldenEgg: Int = waves.maxGoldenEggs(eventType: eventType, waterLevel: waterLevel) {
//                        self.goldenEggs[waterLevel.rawValue][eventType.rawValue] = GoldenEggsRecord(goldenEggs: goldenEgg)
//                    }
//                }
//            }
//        }
//    }
//}
//
//#warning("将来的にこれ削除したい")
//struct GoldenEggsRecord {
//    var goldenEggs: Int?
//    var playTime: Int? = 0
//    var tide: Int = 0
//    var event: Int = 0
//}
