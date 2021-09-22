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
    /// リザルト一覧で表示するためのリザルト
    var results: [UserCoopResult] {
        let startTime: [Int] = Array(Set(RealmManager.shared.results.map({ $0.startTime }))).sorted(by: >)
        return startTime.map({ UserCoopResult(startTime: $0) })
    }
    
    /// どこで使っているのかわからない選択中のプレイヤーの全リザルト
    var result: RealmSwift.Results<RealmCoopResult> {
        RealmManager.shared.results(playerId: manager.playerId)
    }
    
    /// 各WAVEの勝率とかを求めるやつ
    
    /// ステージ記録一覧
    var records: [CoopRecord] {
        return StageType.allCases.map{ CoopRecord(stageId: $0.rawValue) }
    }
    
    init() {
        // 不要だとは思うが念の為にアップデートする
        token = RealmManager.shared.results.observe { [weak self] _ in
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
        self.waves = [0, 1, 2].map({ Result(success: results.filter("isClear==true OR failureWave > %@", $0).count,
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
        let results = RealmManager.shared.results(startTime: startTime)
        let waves = RealmManager.shared.waves(startTime: startTime)
        getRecordsFromDatabase(results: results, waves: waves)
    }
    
    // ステージごとの記録
    init(stageId: Int) {
        let results = RealmManager.shared.results(stageId: stageId)
        let waves = RealmManager.shared.waves(stageId: stageId)
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
