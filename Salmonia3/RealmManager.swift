//
//  RealmManager.swift
//  Salmonia3
//
//  Created by Devonly on 3/13/21.
//

import Foundation
import RealmSwift
import Realm
import SalmonStats
import SplatNet2
import Combine

final class RealmManager {
    
    static let shared = RealmManager()
    private var task = Set<AnyCancellable>()
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
    }
    
    // 統計情報を更新
    public static func updateSummary(from summary: Response.SummaryCoop) throws {
        #warning("マルチアカウント対応")
        guard let account = RealmManager.shared.realm.objects(RealmUserInfo.self).filter("nsaid=%@", SplatNet2.shared.playerId).first else { throw APPError.realm }
        RealmManager.shared.realm.beginWrite()
        account.goldenIkuraTotal = summary.summary.card.goldenIkuraTotal
        account.ikuraTotal = summary.summary.card.ikuraTotal
        account.jobNum = summary.summary.card.jobNum
        try RealmManager.shared.realm.commitWrite()
    }
    
    public static func updateUserNickname(players: [PlayerMetadata]) {
        RealmManager.shared.realm.beginWrite()
        for player in players {
            let account = RealmManager.shared.realm.objects(RealmPlayerResult.self).filter("pid=%@", player.pid)
            account.setValue(player.name, forKey: "name")
        }
        try? RealmManager.shared.realm.commitWrite()
    }
    
    public static func getActiveAccountsIsEmpty() -> Bool {
        return RealmManager.shared.realm.objects(RealmUserInfo.self).isEmpty
    }
    
    // 最新のバイトIDを取得
    public static func getLatestResultId() -> Int {
        return RealmManager.shared.realm.objects(RealmUserInfo.self).first?.jobNum ?? -1
    }
    
    public static func addNewRotation(from rotation: [Response.ScheduleCoop]) throws {
        RealmManager.shared.realm.beginWrite()
        let rotations: [RealmCoopShift] = rotation.map{ RealmCoopShift(from: $0) }
        rotations.map{ RealmManager.shared.realm.create(RealmCoopShift.self, value: $0, update: .all) }
        try? RealmManager.shared.realm.commitWrite()
    }
    // シフトスケジュールを取得
    public static func getShiftSchedule(startTime: Int) throws -> RealmCoopShift {
        guard let realm = try? Realm() else { throw APPError.realm }
        guard let schedule = realm.objects(RealmCoopShift.self).filter("startTime=%@", startTime).first else { throw APPError.realm }
        return schedule
    }
    
    // 新規アカウント追加
    public static func addNewAccount(from account: Response.UserInfo) throws {
        guard let realm = try? Realm() else { return }
        realm.beginWrite()
        realm.create(RealmUserInfo.self, value: RealmUserInfo(from: account), update: .all)
        try realm.commitWrite()
    }
    
    // ユーザ情報を更新
    public static func updateUserInfo(from account: Response.UserInfo) throws {
        
    }
    
    public static func addNewResultsFromSplatNet2(from result: SplatNet2.Coop.Result, pid: String) {
        RealmManager.shared.realm.beginWrite()
        let result: RealmCoopResult = RealmCoopResult(from: result, pid: pid)
        switch result.isDuplicated {
        case true:
            // SalmonIdのみアップデート
            // 被っているplayTimeを取得
            print("DUPLICATED")
            if let duplicate = result.duplicatedResult {
                duplicate.setValue(result.salmonId, forKey: "salmonId")
            }
        case false:
            // 書き込み
            RealmManager.shared.realm.create(RealmCoopResult.self, value: result, update: .all)
        }
        try? RealmManager.shared.realm.commitWrite()
    }

    // Salmon Statsからのリザルト追加
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

struct PlayerMetadata {
    var pid: String
    var name: String
    var thumbnailUrl: String
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
