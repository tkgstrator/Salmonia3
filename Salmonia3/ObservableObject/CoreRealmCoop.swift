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
    private var token: NSObserver = NSObserver()
    
    // 実際に使いそうなデータ
    @Published var results: RealmSwift.Results<RealmCoopResult> = RealmManager.shared.realm.objects(RealmCoopResult.self).sorted(byKeyPath: "playTime", ascending: false)
    @Published var shifts: RealmSwift.Results<RealmCoopShift> = RealmManager.shared.realm.objects(RealmCoopShift.self).sorted(byKeyPath: "startTime", ascending: false)
    @Published var records: [StageRecord] = Array(repeating: StageRecord(), count: 5)
    @AppStorage("FEATURE_FREE_01") var isFree01: Bool = false // クマブキアンロック
    @AppStorage("FEATURE_FREE_02") var isFree02: Bool = false // 将来のシフト
    @AppStorage("FEATURE_FREE_03") var isFree03: Bool = false
    
    private func observer() {
        // 将来のシフト表示が切り替わったとき
        token.futureRotation = UserDefaults.standard.observe(\.FEATURE_FREE_02, options: [.initial, .new], changeHandler: { [self] (_, _) in
            switch isFree02 {
            case true:
                // 全部表示
                shifts = RealmManager.shared.realm.objects(RealmCoopShift.self).sorted(byKeyPath: "startTime", ascending: false)
            case false:
                // 一部だけ表示
                let currentTime: Int = Int(Date().timeIntervalSince1970)
                guard let nextShiftStartTime: Int = RealmManager.shared.realm.objects(RealmCoopShift.self)
                        .sorted(byKeyPath: "startTime", ascending: true)
                        .filter("startTime>=%@", currentTime)
                        .first?.startTime else { return }
                shifts = RealmManager.shared.realm.objects(RealmCoopShift.self)
                    .sorted(byKeyPath: "startTime", ascending: false)
                    .filter("startTime<=%@", nextShiftStartTime)
            }
        })
    }

    init() {
        token.realm = RealmManager.shared.realm.objects(RealmCoopResult.self).observe { [self] _ in
            observer()
            results = RealmManager.shared.realm.objects(RealmCoopResult.self).sorted(byKeyPath: "playTime", ascending: false)
            for stageId in Range(5000 ... 5004) {
                records[5000 - stageId] = StageRecord(stageId: stageId)
            }
        }
        
        token.realm = RealmManager.shared.realm.objects(RealmUserInfo.self).observe { [self] _ in
            observer()
            results = RealmManager.shared.realm.objects(RealmCoopResult.self).sorted(byKeyPath: "playTime", ascending: false)
        }
    }
    
    deinit {
        token.futureRotation?.invalidate()
    }
}

fileprivate struct NSObserver {
    var realm: NotificationToken?
    var rareWeapon: NSKeyValueObservation?
    var futureRotation: NSKeyValueObservation?
}

// MARK: ブキ支給情報
struct WeaponList: Hashable {
    var weaponId: Int
    var count: Int?
    var image: String {
        return ""
    }
}

// MARK: ステージキロク
class StageRecord: ObservableObject {
    @Published var jobNum: Int?
    @Published var maxGrade: Int?
    @Published var goldenEggs: [[GoldenEggsRecord?]] = Array(repeating: Array(repeating: nil, count: 7), count: 3)
    
    init() {}
    
    init(stageId: Int) {
        let results = RealmManager.shared.realm.objects(RealmCoopResult.self).filter("stageId=%@", stageId)
        let waves = RealmManager.shared.realm.objects(RealmCoopWave.self).filter("ANY result.stageId=%@", stageId)
        
        if results.count != 0 {
            self.jobNum = results.count
            self.maxGrade = results.max(ofProperty: "gradePoint")
            
            for tide in Range(0 ... 2) {
                let waterLevel = WaterLevel.init(rawValue: tide)!.waterLevel
                for event in Range(0 ... 6) {
                    let eventType = EventType.init(rawValue: event)!.eventType
                    let goldenEgg: Int? = waves.filter("eventType=%@ AND waterLevel=%@", eventType, waterLevel).max(ofProperty: "goldenIkuraNum")
                    if let goldenEgg = goldenEgg {
                        self.goldenEggs[tide][event] = GoldenEggsRecord(goldenEggs: goldenEgg, playTime: nil, tide: tide, event: event)
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
}
