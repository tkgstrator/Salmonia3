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

final class RealmManager: AppManager {
    private static let realm: Realm = try! Realm()
    class Objects {
        private static let realm: Realm = try! Realm()
        
        // MARK: RealmCoopShift
        static func shift(startTime: Int) -> RealmCoopShift {
            return realm.objects(RealmCoopShift.self)
                .filter("startTime=%@", startTime).first!
        }

        // MARK: RealmCoopResult
        // 全リザルトを返す
        static var results: RealmSwift.Results<RealmCoopResult> {
            return realm.objects(RealmCoopResult.self)
                .filter("pid=%@", manager.account.nsaid)
                .sorted(byKeyPath: "playTime", ascending: false)
        }

        // シフトIDを指定して返す
        static func results(startTime: Int) -> RealmSwift.Results<RealmCoopResult> {
            return realm.objects(RealmCoopResult.self)
                .filter("pid=%@ AND startTime=%@", manager.account.nsaid, startTime)
                .sorted(byKeyPath: "playTime", ascending: false)
        }

        // シフトIDを指定して返す
        static func results(startTime: Int, playerId: String) -> RealmSwift.Results<RealmCoopResult> {
            return realm.objects(RealmCoopResult.self)
                .filter("pid=%@ AND startTime=%@", playerId, startTime)
                .sorted(byKeyPath: "playTime", ascending: false)
        }

        // ステージIDを指定して返す
        static func results(stageId: Int) -> RealmSwift.Results<RealmCoopResult> {
            return realm.objects(RealmCoopResult.self)
                .filter("pid=%@ AND stageId=%@", manager.account.nsaid, stageId)
                .sorted(byKeyPath: "playTime", ascending: false)
        }
        
        //
        static func results(playerId: String) -> RealmSwift.Results<RealmCoopResult> {
            return realm.objects(RealmCoopResult.self)
                .filter("pid=%@", playerId)
                .sorted(byKeyPath: "playTime", ascending: false)
        }

        // MARK: RealmCoopWave
        // 全WAVEリザルトを返す
        static var waves: RealmSwift.Results<RealmCoopWave> {
            return realm.objects(RealmCoopWave.self)
                .filter("ANY result.pid=%@", manager.account.nsaid)
                .sorted(byKeyPath: "goldenIkuraNum", ascending: false)
        }
        
        static func waves(startTime: Int) -> RealmSwift.Results<RealmCoopWave> {
            return realm.objects(RealmCoopWave.self)
                .filter("ANY result.pid=%@ AND ANY result.startTime=%@", manager.account.nsaid, startTime)
        }
        
        static func waves(stageId: Int) -> RealmSwift.Results<RealmCoopWave> {
            return realm.objects(RealmCoopWave.self)
                .filter("ANY result.pid=%@ AND ANY result.stageId=%@", manager.account.nsaid, stageId)
        }

        // MARK: RealmPlayerResult
        static func playerResults(startTime: Int, playerId: String) -> RealmSwift.Results<RealmPlayerResult> {
            return realm.objects(RealmPlayerResult.self)
                .filter("pid=%@ AND ANY result.startTime=%@", playerId, startTime)
        }

        static func playerResults(playerId: String) -> RealmSwift.Results<RealmPlayerResult> {
            return realm.objects(RealmPlayerResult.self)
                .filter("pid=%@", playerId)
        }

        static func playerResults(startTime: Int) -> RealmSwift.Results<RealmPlayerResult> {
            return realm.objects(RealmPlayerResult.self)
                .filter("pid=%@ AND ANY result.startTime=%@", manager.playerId, startTime)
        }

        // MARK: RealmPlayer
        // マッチングしたプレイヤーを返す
        static var players: RealmSwift.Results<RealmPlayer> {
            return realm.objects(RealmPlayer.self)
                .filter("nsaid!=%@", manager.account.nsaid)
                .sorted(byKeyPath: "lastMatchedTime", ascending: false)
        }
    }
    
    private var task = Set<AnyCancellable>()

    override init() {
    }
    
    //
    public static func getCoopResults(startTime: Int? = nil, pid: String? = nil) -> RealmSwift.Results<RealmCoopResult> {
        let realm = try! Realm()
        if let startTime = startTime, let pid = pid {
            return realm.objects(RealmCoopResult.self).filter("startTime=%@ AND pid=%@", startTime, pid)
        }
        if let startTime = startTime {
            return realm.objects(RealmCoopResult.self).filter("startTime=%@", startTime)
        }
        if let pid = pid {
            return realm.objects(RealmCoopResult.self).filter("pid=%@", pid)
        }
        return realm.objects(RealmCoopResult.self)
    }
        
    
    // そのプレイヤーが参加していたシフトのスケジュールを取得
    public static func getPlayerShiftStartTime(nsaid: String) -> [Int] {
        return Array(Set(realm.objects(RealmCoopResult.self).filter("ANY player.pid=%@", nsaid).map{ $0.startTime })).sorted(by: >)
    }
    
    // そのプレイヤーが参加していたシフトのデータを取得
    public static func getPlayerShiftResults(nsaid: String) -> [UserCoopResult] {
        return getPlayerShiftStartTime(nsaid: nsaid).map({ UserCoopResult(startTime: $0, playerId: nsaid)})
    }

    public static func updateUserNickname(players: [PlayerMetadata]) {
        realm.beginWrite()
        for player in players {
            let account = realm.objects(RealmPlayerResult.self).filter("pid=%@", player.pid)
            account.setValue(player.name, forKey: "name")
        }
        try? realm.commitWrite()
    }

    // 最新のバイトIDを取得
    public static func getLatestResultId() -> Int {
        let nsaid = manager.account.nsaid
        guard let realm = try? Realm() else { return 0 }
        let jobNum: Int? = realm.objects(RealmCoopResult.self).filter("pid=%@", nsaid).max(ofProperty: "jobId")
        if let jobNum = jobNum {
            return jobNum
        } else {
            return 0
        }
    }
    
    public static func addNewRotation(from rotation: [Response.ScheduleCoop]) throws {
        realm.beginWrite()
        let rotations: [RealmCoopShift] = rotation.map{ RealmCoopShift(from: $0) }
        let _ = rotations.map{ realm.create(RealmCoopShift.self, value: $0, update: .all) }
        try? realm.commitWrite()
    }
    // シフトスケジュールを取得
    public static func getShiftSchedule(startTime: Int) throws -> RealmCoopShift {
        guard let realm = try? Realm() else { throw APPError.realm }
        guard let schedule = realm.objects(RealmCoopShift.self).filter("startTime=%@", startTime).first else { throw APPError.realm }
        return schedule
    }

    public static func getNicknames() -> [String] {
        return Array(Set(realm.objects(RealmPlayerResult.self).map{ $0.pid }))
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
    public static func addNewResultsFromSplatNet2(from results: [SplatNet2.Coop.Result], pid: String) {
        DispatchQueue(label: "Realm Manager").async {
            autoreleasepool {
                guard let realm = try? Realm() else { return }
                realm.beginWrite()
                for result in results {
                    let result: RealmCoopResult = RealmCoopResult(from: result, pid: pid)
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
        guard let realm = try? Realm() else { fatalError() }
        return realm.objects(RealmCoopResult.self).filter("playTime BETWEEN %@", [self.playTime - 5, self.playTime + 5])
    }
}
