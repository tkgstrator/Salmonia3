//
//  AppService+Realm.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/31.
//

import Foundation
import RealmSwift
import SplatNet2
import SalmonStats
import CocoaLumberjackSwift

extension AppService {
    /// PrimaryKeyを指定したオブジェクトを取得
    @discardableResult
    func object<T: Object>(ofType type: T.Type, forPrimaryKey key: String?) -> T? {
        realm.object(ofType: type, forPrimaryKey: key)
    }
    
    /// 指定したオブジェクトを全て取得
    @discardableResult
    func objects<T: Object>(ofType type: T.Type) -> RealmSwift.Results<T> {
        realm.objects(type)
    }
    
    /// シフトに対して書き込みをする
    internal func save<T: Object>(_ objects: [T]) {
        if realm.isInWriteTransaction {
            realm.add(objects, update: .modified)
        } else {
            realm.beginWrite()
            realm.add(objects, update: .modified)
            try? realm.commitWrite()
        }
    }
    
    /// シフトに対して書き込みをする
    internal func save(_ results: [RealmCoopResult]) {
        let schedules = objects(ofType: RealmCoopShift.self)
        
        if realm.isInWriteTransaction {
            realm.add(results, update: .modified)
            for result in results {
                if let schedule = schedules.first(where: { $0.startTime == result.startTime }),
                   !schedule.results.contains(result)
                {
                    schedule.results.append(objectsIn: [result])
                }
            }
        } else {
            realm.beginWrite()
            realm.add(results, update: .modified)
            for result in results {
                if let schedule = schedules.first(where: { $0.startTime == result.startTime }),
                   !schedule.results.contains(result)
                {
                    schedule.results.append(objectsIn: [result])
                }
            }
            try? realm.commitWrite()
        }
    }
    
    /// シフトに対して書き込みをする
    private func save<T: Object>(_ object: T) {
        if realm.isInWriteTransaction {
            realm.create(T.self, value: object, update: .modified)
        } else {
            try? realm.write {
                realm.create(T.self, value: object, update: .modified)
            }
        }
    }
    
    /// Firestoreから取得したリザルトを保存
    internal func save(results: [FSCoopResult]) {
        let objects: [RealmCoopResult] = results.map({ RealmCoopResult(result: $0) })
        self.save(objects)
    }
    
    /// SplatNet2から取得したリザルトを保存
    internal func save(results: [SalmonResult]) {
        let objects: [RealmCoopResult] = results.map({ RealmCoopResult(from: $0.result, id: $0.id) })
        self.save(objects)
    }
    
    /// シフト情報をRealmに追加
    func addLatestShiftSchedule() {
        if realm.objects(RealmCoopShift.self).isEmpty {
            DDLogInfo(SplatNet2.schedule.count)
            self.save(SplatNet2.schedule.map({ RealmCoopShift(from: $0) }))
        }
    }
    
    func getVisibleSchedules() -> [RealmCoopShift] {
        /// 現在時刻を取得
        let currentTime: Int = Int(Date().timeIntervalSince1970)
        
        /// 開催中のシフト+開催時間が今よりもあとのものを取得
        let schedules: RealmSwift.Results<RealmCoopShift> = {
            let schedules: RealmSwift.Results<RealmCoopShift> = realm.objects(RealmCoopShift.self).sorted(byKeyPath: "startTime", ascending: false)

            switch shiftDisplayMode {
            case .all:
                return schedules
            case .current:
                return schedules.filter("(startTime<=%@ AND endTime>=%@) OR startTime<=%@", currentTime, currentTime, currentTime)
            case .played:
                return schedules.filter("(startTime<=%@ AND endTime>=%@) OR startTime<=%@", currentTime, currentTime, currentTime)
            }
        }()
        
        return Array(schedules)
    }
    
    func deleteAllResultsFromDatabase() {
        if realm.isInWriteTransaction {
            realm.deleteAll()
        } else {
            try? realm.write({
                realm.deleteAll()
            })
        }
    }
}
