//
//  RealmManager.swift
//  Salmonia3
//
//  Created by Devonly on 3/13/21.
//

import Foundation
import RealmSwift
import Realm
import SwiftyJSON

enum RealmManager {

    public static func migration() {
        // データベースのマイグレーションをする
        let config = Realm.Configuration(
            schemaVersion: 2048,
            migrationBlock: { migration, schemaVersion in
                if schemaVersion <= 512 {
                    let formatter: ISO8601DateFormatter = {
                        let formatter = ISO8601DateFormatter()
                        formatter.timeZone = TimeZone.current
                        return formatter
                    }()

                    migration.enumerateObjects(ofType: RealmCoopShift.className()) { old, new in
                        new!["startTime"] = Int((formatter.date(from: old!["startTime"] as! String)!).timeIntervalSince1970)
                        new!["endTime"] = Int((formatter.date(from: old!["endTime"] as! String)!).timeIntervalSince1970)
                    }
                }

                if schemaVersion <= 1024 {
                    let formatter: ISO8601DateFormatter = {
                        let formatter = ISO8601DateFormatter()
                        formatter.timeZone = TimeZone.current
                        return formatter
                    }()

                    migration.enumerateObjects(ofType: RealmCoopResult.className()) { old, new in
                        new!["startTime"] = Int((formatter.date(from: old!["startTime"] as! String)!).timeIntervalSince1970)
                        new!["playTime"] = Int((formatter.date(from: old!["playTime"] as! String)!).timeIntervalSince1970)
                        new!["endTime"] = Int((formatter.date(from: old!["endTime"] as! String)!).timeIntervalSince1970)
                    }
                }
                // schemaVersionが上がると呼び出される
                print("MIGRATION NEEDED")
            })
        Realm.Configuration.defaultConfiguration = config
        try? RealmManager.addNewRotation()
    }

    public static func updateUserInfo(pid: String, summary: JSON) throws {
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

    public static func addNewAccount(account: RealmUserInfo) throws {
        guard let realm = try? Realm() else { return }
        realm.beginWrite()
        realm.create(RealmUserInfo.self, value: account, update: .all)
        try realm.commitWrite()
    }

    public static func addNewResult(from results: [JSON]) throws {
        guard let realm = try? Realm() else { return }
        realm.beginWrite()
        for result in results {
            let result = try JSONDecoder().decode(RealmCoopResult.self, from: result.rawData())
            realm.create(RealmCoopResult.self, value: result, update: .all)
        }
        try realm.commitWrite()
    }

    public static func updateResult(from response: SalmonStats.UploadResult) throws {
        guard let realm = try? Realm() else { return }
        realm.beginWrite()
        for id in response.results.map { (splatnet2: $0.jobId, salmonstats: $0.salmonId) } {
            let result = realm.objects(RealmCoopResult.self).filter("jobId=%@", id.splatnet2)
            result.setValue(id.salmonstats, forKey: "salmonId")
        }
        try realm.commitWrite()
    }

    private static func addNewRotation() throws {
        ProductManger.getFutureRotation { response, _ in
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

    public static func setIksmSession(nsaid: String, account: JSON) throws {
        let user = try JSONDecoder().decode(RealmUserInfo.self, from: account.rawData())
        guard let realm = try? Realm() else { return }
        let account = realm.objects(RealmUserInfo.self).filter("nsaid=%@", nsaid)
        realm.beginWrite()
        account.setValue(user.nickname, forKey: "nickname")
        account.setValue(user.thumbnailURL, forKey: "thumbnailURL")
        account.setValue(user.iksmSession, forKey: "iksmSession")
        try? realm.commitWrite()
    }

    static func eraseAllRecord() throws {
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
