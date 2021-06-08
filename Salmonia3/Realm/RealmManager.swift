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
            schemaVersion: 4098,
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
    
    // そのプレイヤーが参加していたシフトのスケジュールを取得
    public static func getPlayerShiftStartTime(nsaid: String) -> [Int] {
        return Array(Set(RealmManager.shared.realm.objects(RealmCoopResult.self).filter("ANY player.pid=%@", nsaid).map{ $0.startTime })).sorted(by: >)
    }
    
    // そのプレイヤーが参加していたシフトのデータを取得
    public static func getPlayerShiftResults(nsaid: String) -> [UserCoopResult] {
        return getPlayerShiftStartTime(nsaid: nsaid).map({ UserCoopResult(startTime: $0, pid: nsaid)})
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
        let _ = rotations.map{ RealmManager.shared.realm.create(RealmCoopShift.self, value: $0, update: .all) }
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
    
    public static func getNicknames() -> [String] {
        return Array(Set(RealmManager.shared.realm.objects(RealmPlayerResult.self).map{ $0.pid! }))
    }
 
    // MARK: ユーザ名やサムネイルを更新し、RealmPlayerのオブジェクトを作成
    public static func updateNicknameAndIcons(players: [Response.NicknameIcons.NicknameIcon]) {
        DispatchQueue(label: "Realm Manager").async {
            autoreleasepool {
                guard let realm = try? Realm() else { return }
                realm.beginWrite()
                for player in players {
                    realm.create(RealmPlayer.self, value: RealmPlayer(from: player), update: .all)
                    let result = realm.objects(RealmPlayerResult.self).filter("pid=%@", player.nsaId)
                    result.setValue(player.nickname, forKey: "name")
                }
                try? realm.commitWrite()
            }
        }
    }
    
    // MARK: 新しいプレイヤーを追加/更新
    public static func addNewNicknameAndIcons(nsaid: [String]) {
        
    }

    // MARK: 新しいリザルトを追加
    public static func addNewResultsFromSplatNet2(from result: SplatNet2.Coop.Result, pid: String) {
        RealmManager.shared.realm.beginWrite()
        let result: RealmCoopResult = RealmCoopResult(from: result, pid: pid)
        switch !result.duplicatedResult.isEmpty {
        case true:
            result.duplicatedResult.setValue(result.salmonId, forKey: "salmonId")
        case false:
            RealmManager.shared.realm.create(RealmCoopResult.self, value: result, update: .all)
        }
        try? RealmManager.shared.realm.commitWrite()
    }

    // MARK: Salmon Statsからのリザルト追加
    public static func addNewResultsFromSalmonStats(from results: [SalmonStats.ResultCoop], pid: String) {
        DispatchQueue(label: "Realm Manager").async {
            autoreleasepool {
                guard let realm = try? Realm() else { return }
                realm.beginWrite()
                let results: [RealmCoopResult] = results.map{ RealmCoopResult(from: $0, pid: pid) }
                for result in results {
                    switch !result.duplicatedResult.isEmpty {
                    case true:
                        result.duplicatedResult.setValue(result.salmonId, forKey: "salmonId")
                    case false:
                        realm.create(RealmCoopResult.self, value: result, update: .all)
                    }
                }
                try? realm.commitWrite()
            }
        }
    }
    
    static func eraseAllRecord() throws {
        guard let realm = try? Realm() else { return }
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        // クラッシュするバグ対策(クラッシュしたが)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            autoreleasepool {
                realm.beginWrite()
                realm.delete(realm.objects(RealmCoopResult.self))
                realm.delete(realm.objects(RealmCoopWave.self))
                realm.delete(realm.objects(RealmPlayer.self))
                realm.delete(realm.objects(RealmPlayerResult.self))
                //                realm.delete(realm.objects(RealmUserInfo.self))
                try? realm.commitWrite()
            }
        }
    }
}

struct PlayerMetadata {
    var pid: String
    var name: String
    var thumbnailUrl: String
}

fileprivate extension RealmCoopResult {
    var duplicatedResult: RealmSwift.Results<RealmCoopResult> {
        return RealmManager.shared.realm.objects(RealmCoopResult.self).filter("playTime BETWEEN %@", [self.playTime - 5, self.playTime + 5])
    }
}
