//
//  RealmManager.swift
//  Salmonia3
//
//  Created by Devonly on 3/13/21.
//

import Foundation
import RealmSwift
import SwiftyJSON

enum RealmManager {
    public static func migration() {
        // データベースのマイグレーションをする
        let config = Realm.Configuration(
            schemaVersion: 5,
            migrationBlock: { [self] migration, version in
                if version < 1 {
                    // マイグレーションブロック
                }
            },
            deleteRealmIfMigrationNeeded: true
            )
        Realm.Configuration.defaultConfiguration = config
        try? RealmManager.addNewRotation()
    }
    
    public static func addNewAccount(account: RealmUserInfo) throws -> () {
        guard let realm = try? Realm() else { return }
        realm.beginWrite()
        realm.create(RealmUserInfo.self, value: account, update: .all)
        try realm.commitWrite()
    }

    public static func addNewResult(from results: [JSON]) throws -> () {
        guard let realm = try? Realm() else { return }
        realm.beginWrite()
        for result in results {
            let result = try JSONDecoder().decode(RealmCoopResult.self, from: result.rawData())
            realm.create(RealmCoopResult.self, value: result, update: .all)
        }
        try realm.commitWrite()
    }
    
    public static func addNewRotation() throws -> () {
        ProductManger.getFutureRotation { response, error in
            guard let response = response else { return }
            guard let realm = try? Realm() else { return }
            realm.beginWrite()
            for (_, data) in response {
                let value = try? JSONDecoder().decode(RealmCoopShift.self, from: data.rawData())
                realm.create(RealmCoopShift.self, value: value, update: .all)
            }
            try? realm.commitWrite()
        }
    }
    
    public static func setIksmSession(iksmSession: String, pid: String) {
        guard let realm = try? Realm() else { return }
        realm.beginWrite()
        realm.objects(RealmUserInfo.self).filter("nsaid=%@", pid).setValue(iksmSession, forKey: "iksmSession")
        try? realm.commitWrite()
    }
    
    static func eraseAllRecord() throws -> () {
        guard let realm = try? Realm() else { return }
        autoreleasepool {
            realm.beginWrite()
            realm.delete(realm.objects(RealmCoopWave.self))
            realm.delete(realm.objects(RealmCoopResult.self))
            realm.delete(realm.objects(RealmPlayerResult.self))
            try? realm.commitWrite()
        }
    }
}
