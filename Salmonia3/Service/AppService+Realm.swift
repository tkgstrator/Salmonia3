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
    func objecst<T: Object>(ofType type: T.Type) -> RealmSwift.Results<T> {
        realm.objects(type)
    }
    
    internal func save<T: Object>(_ objects: [T]) {
        if realm.isInWriteTransaction {
            for object in objects {
                realm.create(T.self, value: object, update: .all)
            }
        } else {
            realm.beginWrite()
            for object in objects {
                realm.create(T.self, value: object, update: .all)
            }
            try? realm.commitWrite()
        }
    }
    
    internal func save<T: Object>(_ object: T) {
        if realm.isInWriteTransaction {
            realm.create(T.self, value: object, update: .all)
        } else {
            try? realm.write {
                realm.create(T.self, value: object, update: .all)
            }
        }
    }
    
    internal func save(results: [(id: Int, status: UploadStatus, result: CoopResult.Response)]) {
        let objects: [RealmCoopResult] = results.map({ RealmCoopResult(from: $0.result, id: $0.id) })
        self.save(objects)
    }
    
    /// シフト情報をRealmに追加
    func addLatestShiftSchedule() {
        self.save(SplatNet2.schedule.map({ RealmCoopShift(from: $0) }))
    }
    
    var playedShiftScheduleId: [Int] {
        guard let nsaid = account?.credential.nsaid else {
            return []
        }
        return Array(Set(realm.objects(RealmCoopResult.self).filter("pid=%@", nsaid).map({ $0.startTime })))
    }
}
