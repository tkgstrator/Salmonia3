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

/// ユーザの大まかな記錄
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

    /// 失敗数や成功数の記錄
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

/// リザルト一覧で使うデータ
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

/// ステージごとの金イクラ記錄
class UserCoopRecord: Identifiable {
    var id: UUID = UUID()
    var records: [Record] = []
    var overview: [Overview] = []

    internal init() {
        for stageId in StageType.allCases {
            let waves = RealmManager.shared.allWaves(stageId: stageId.rawValue)
            let results = RealmManager.shared.allResults(stageId: stageId.rawValue)
            /// 概要を追加
            overview.append(Overview(stageId: stageId, results: results))

            // 夜込み最高記録を計算
            let total = Array(results.sorted(byKeyPath: "goldenEggs", ascending: false).prefix(3)).map({ Record(stageId: stageId, playTime: $0.playTime, powerEggs: $0.powerEggs, goldenEggs: $0.goldenEggs, players: $0.players, weaponList: $0.weaponList, recordType: .total) })
            records.append(contentsOf: total)

            // 昼のみ最高記録を計算
            let nonight = results.filter("SUBQUERY(wave, $wave, $wave.eventType=%@).@count==3", 0).sorted(byKeyPath: "goldenEggs", ascending: false).prefix(3).map({ Record(stageId: stageId, playTime: $0.playTime, powerEggs: $0.powerEggs, goldenEggs: $0.goldenEggs, players: $0.players, weaponList: $0.weaponList, recordType: .nonight) })
            records.append(contentsOf: nonight)

            // 各イベント・潮位についてTOP3の記録を抽出
            for eventType in EventType.allCases {
                for waterLevel in WaterLevel.allCases {
                    let results = Array(waves.filter("eventType=%@ AND waterLevel=%@", eventType.rawValue, waterLevel.rawValue).sorted(byKeyPath: "goldenIkuraNum", ascending: false).prefix(3))
                    let record = results.map({ Record(stageId: stageId, playTime: $0.playTime, waterLevel: waterLevel, eventType: eventType, powerEggs: $0.ikuraNum, goldenEggs: $0.goldenIkuraNum, players: $0.players, weaponList: $0.weaponList) })
                    records.append(contentsOf: record)
                }
            }
        }
    }
    
    /// ステージごとの大まかな記錄
    struct Overview: Identifiable, Hashable {
        var id: Int { stageId.rawValue }
        var stageId: StageType
        var jobNum: Int?
        var maxGrade: Int?
        var counter999Num: Int?
        var counter999StepNum: Int?
        
        internal init(stageId: StageType, results: RealmSwift.Results<RealmCoopResult>) {
            self.stageId = stageId
            self.jobNum = results.count == 0 ? nil : results.count
            self.counter999Num = results.counterStepNum == 0 ? nil : results.counterStepNum
            self.counter999StepNum = results.minimumStepNum
            self.maxGrade = results.max(ofProperty: "gradePoint")
        }
    }
    
    /// 納品記錄
    class Record: Identifiable {
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
