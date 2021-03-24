//
//  RealmManager.swift
//  Salmonia3
//
//  Created by Devonly on 3/13/21.
//

import Foundation
import RealmSwift
import SwiftyJSON
import SwiftUI

enum RealmManager {
    
    public static func migration() {
        // データベースのマイグレーションをする
        let config = Realm.Configuration(
            schemaVersion: 6,
            migrationBlock: { [self] migration, version in
                if version < 1 {
                    // マイグレーションブロック
                }
            })
        Realm.Configuration.defaultConfiguration = config
        try? RealmManager.addNewRotation()
    }
    
    public static func updateUserInfo(pid: String, summary: JSON) throws -> () {
        guard let realm = try? Realm() else { return }
        let user = try JSONDecoder().decode(RealmUserInfo.self, from: summary["summary"]["card"].rawData())
        let account = realm.objects(RealmUserInfo.self).filter("nsaid=%@", pid)
        realm.beginWrite()
        account.setValue(user.jobNum, forKey: "jobNum")
        account.setValue(user.goldenIkuraTotal, forKey: "goldenIkuraTotal")
        account.setValue(user.helpTotal, forKey: "helpTotal")
        account.setValue(user.ikuraTotal, forKey: "ikuraTotal")
        account.setValue(user.kumaPoint, forKey: "kumaPoint")
        account.setValue(user.kumaPointTotal, forKey: "kumaPointTotal")
        try realm.commitWrite()
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
    
    private static func addNewRotation() throws -> () {
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
    
    public static func setIksmSession(account: JSON) throws -> () {
        let user = try JSONDecoder().decode(RealmUserInfo.self, from: account.rawData())
        guard let realm = try? Realm() else { return }
        let account = realm.objects(RealmUserInfo.self).filter("nsaid=%@", user.nsaid)
        realm.beginWrite()
        account.setValue(user.nickname, forKey: "nickname")
        account.setValue(user.thumbnailURL, forKey: "thumbnailURL")
        account.setValue(user.iksmSession, forKey: "iksmSession")
        try? realm.commitWrite()
    }
    
    static func eraseAllRecord() throws -> () {
        guard let realm = try? Realm() else { return }
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        autoreleasepool {
            realm.beginWrite()
            realm.delete(realm.objects(RealmCoopWave.self))
            realm.delete(realm.objects(RealmCoopResult.self))
            realm.delete(realm.objects(RealmPlayerResult.self))
            try? realm.commitWrite()
        }
    }
}
