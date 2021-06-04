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

class CoreRealmCoop: ObservableObject {
    @ObservedObject var appManager: AppManager = AppManager()
    @Published var resultCount: Int = RealmManager.shared.realm.objects(RealmCoopResult.self).count
    @Published var waves: RealmSwift.Results<RealmCoopWave> = RealmManager.shared.realm.objects(RealmCoopWave.self).sorted(byKeyPath: "goldenIkuraNum", ascending: false)
    @Published var results: [UserCoopResult] = []
    
    var records: [CoopRecord] {
        return Range(5000 ... 5004).map{ CoopRecord(stageId: $0) }
    }
    
    private var realmObserver: [NotificationToken?] = Array(repeating: nil, count: 2)
    
    private var nextShiftStartTime: Int {
        appManager.isFree02 ? 1643976000 : RealmManager.shared.realm.objects(RealmCoopShift.self)
            .filter("startTime>=%@", Int(Date().timeIntervalSince1970))
            .min(ofProperty: "startTime") ?? 1500616800
    }
    var currentShiftNumber: Int {
        !appManager.isFree02 ? 0 : RealmManager.shared.realm.objects(RealmCoopShift.self).sorted(byKeyPath: "startTime", ascending: false)
            .sorted(byKeyPath: "startTime", ascending: false)
            .filter("startTime>=%@", Int(Date().timeIntervalSince1970))
            .count
    }
    var shifts: RealmSwift.Results<RealmCoopShift> {
        RealmManager.shared.realm.objects(RealmCoopShift.self).sorted(byKeyPath: "startTime", ascending: false)
            .sorted(byKeyPath: "startTime", ascending: false)
            .filter("startTime<=%@", nextShiftStartTime)
    }
    
    // MARK: 最新の二件のシフト表示
    var latestShifts: [RealmCoopShift] {
        let currentTime: Int = Int(Date().timeIntervalSince1970)
        
        return Array(RealmManager.shared.realm.objects(RealmCoopShift.self)
            .filter("endTime>=%@", currentTime)
            .sorted(byKeyPath: "startTime", ascending: true).prefix(2))
    }
    
    init() {
        realmObserver[0] = RealmManager.shared.realm.objects(RealmCoopResult.self).observe { [self] _ in
            let starTime: [Int] = Array(Set(RealmManager.shared.realm.objects(RealmCoopResult.self).map({ $0.startTime }))).sorted(by: >)
            results = starTime.map{ UserCoopResult(startTime: $0) }
        }
        realmObserver[1] = RealmManager.shared.realm.objects(RealmUserInfo.self).observe { [self] _ in
            objectWillChange.send()
        }
    }
    
    deinit {
        realmObserver[1]?.invalidate()
    }
}

// MARK: リザルト一覧で使うデータ
class UserCoopResult: Identifiable {
    var id: Int
    var phase: RealmCoopShift
    var results: RealmSwift.Results<RealmCoopResult>
    
    init(startTime: Int) {
        self.id = startTime
        self.phase = RealmManager.shared.realm.objects(RealmCoopShift.self).filter("startTime=%@", startTime).first!
        results = RealmManager.shared.realm.objects(RealmCoopResult.self).filter("startTime=%@", startTime).sorted(byKeyPath: "playTime", ascending: false)
    }
}


// MARK: ステージキロク
class CoopRecord: ObservableObject {
    var jobNum: Int?
    var maxGrade: Int?
    var goldenEggs: [[GoldenEggsRecord?]] = Array(repeating: Array(repeating: nil, count: 7), count: 3)

    init() {}
    
    init(startTime: Int) {
        let results = RealmManager.shared.realm.objects(RealmCoopResult.self).filter("startTime=%@", startTime)
        let waves = RealmManager.shared.realm.objects(RealmCoopWave.self).filter("ANY result.startTime=%@", startTime)
        getRecordsFromDatabase(results: results, waves: waves)
    }
    
    init(stageId: Int) {
        let results = RealmManager.shared.realm.objects(RealmCoopResult.self).filter("stageId=%@", stageId)
        let waves = RealmManager.shared.realm.objects(RealmCoopWave.self).filter("ANY result.stageId=%@", stageId)
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
