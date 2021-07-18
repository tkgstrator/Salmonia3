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
    
    private var task = Set<AnyCancellable>()
    
    // 環境設定のためのEnum
    enum Environment {
        enum Server {
            case splatnet2
            case salmonstats
        }
        
        enum System {
            case develop
            case production
        }
    }

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
    
    public static func addNewRotation(from rotation: [ScheduleCoop.Response]) throws {
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
    public static func updateNicknameAndIcons(players: [NicknameIcons.Response.NicknameIcon]) {
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
    public static func addNewResultsFromSplatNet2(from results: [SplatNet2.Coop.Result], _ environment: Environment.Server = .splatnet2) {
        DispatchQueue(label: "Realm Manager").async {
            autoreleasepool {
                guard let realm = try? Realm() else { return }
                realm.beginWrite()
                for result in results {
                    let result: RealmCoopResult = RealmCoopResult(from: result, pid: manager.playerId, environment: environment)
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

    static func eraseAllRecord() throws {
        guard let realm = try? Realm() else { return }
        #if DEBUG
        #else
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        #endif
        // クラッシュするバグ対策(クラッシュしたが)
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
