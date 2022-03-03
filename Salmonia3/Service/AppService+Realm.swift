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
    
    internal func save(results: [(id: Int, status: UploadStatus, result: CoopResult.Response)]) {
        let objects: [RealmCoopResult] = results.map({ RealmCoopResult(from: $0.result, id: $0.id) })
        self.save(objects)
    }
    
    /// シフト情報をRealmに追加
    func addLatestShiftSchedule() {
        if realm.objects(RealmCoopShift.self).isEmpty {
            self.save(SplatNet2.schedule.map({ RealmCoopShift(from: $0) }))
        }
    }
    
    var playedShiftScheduleId: [Int] {
        guard let nsaid = account?.credential.nsaid else {
            return []
        }
        return Array(Set(realm.objects(RealmCoopResult.self).filter("pid=%@", nsaid).map({ $0.startTime })))
    }
}
