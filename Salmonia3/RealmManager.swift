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
import SalmonStats

final class RealmManager {
    
    static let shared = RealmManager()
    let realm: Realm
    
    init() {
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
        realm = try! Realm()
        try? RealmManager.addNewRotation()
    }

    public static func getShiftSchedule(startTime: Int) throws -> RealmCoopShift {
        guard let realm = try? Realm() else { throw APPError.realm }
        guard let shift = realm.objects(RealmCoopShift.self).filter("startTime=%@", startTime).first else { throw APPError.realm }
        return shift
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

    public static func addNewResultsFromSalmonStats(from results: [SalmonStats.ResultCoop], pid: String) {
        RealmManager.shared.realm.beginWrite()
        let results: [RealmCoopResult] = results.map{ RealmCoopResult(from: $0, pid: pid) }
        for result in results {
            switch result.isDuplicated {
            case true:
                // SalmonIdのみアップデート
                // 被っているplayTimeを取得
                if let duplicate = result.duplicatedResult {
                    duplicate.setValue(result.salmonId, forKey: "salmonId")
                }
            case false:
                // 書き込み
                RealmManager.shared.realm.create(RealmCoopResult.self, value: result, update: .all)
            }
        }
        try? RealmManager.shared.realm.commitWrite()
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

//    public static func updateResult(from response: SalmonStats.UploadResult) throws {
//        guard let realm = try? Realm() else { return }
//        realm.beginWrite()
//        for id in response.results.map { (splatnet2: $0.jobId, salmonstats: $0.salmonId) } {
//            let result = realm.objects(RealmCoopResult.self).filter("jobId=%@", id.splatnet2)
//            result.setValue(id.salmonstats, forKey: "salmonId")
//        }
//        try realm.commitWrite()
//    }

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

fileprivate extension RealmCoopResult {
    var isDuplicated: Bool {
        return !(RealmManager.shared.realm.objects(RealmCoopResult.self)
                    .filter("playTime BETWEEN %@", [self.playTime - 5, self.playTime + 5])).isEmpty
    }
    
    var duplicatedResult: RealmCoopResult? {
        return RealmManager.shared.realm.objects(RealmCoopResult.self)
            .filter("playTime BETWEEN %@", [self.playTime - 5, self.playTime + 5]).first
    }
}
