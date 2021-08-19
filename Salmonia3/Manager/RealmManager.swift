//
//  RealmManager.shared.swift
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
    public static let shared = RealmManager()
    internal var realm: Realm
    
    private let schemeVersion: UInt64 = 8192
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

    override private init() {
        do {
            var config = Realm.Configuration.defaultConfiguration
            config.schemaVersion = schemeVersion
            self.realm = try Realm(configuration: config)
        } catch {
            var config = Realm.Configuration.defaultConfiguration
            config.deleteRealmIfMigrationNeeded = true
            config.schemaVersion = schemeVersion
            self.realm = try! Realm(configuration: config)
        }
    }

    /// 直近の二回のバイトシフトのIdを返す
    public var latestShiftStartTime: RealmSwift.Results<RealmCoopShift> {
        // 現在時刻
        let currentTime: Int = Int(Date().timeIntervalSince1970)
        // 現在時刻よりも開始時刻が遅いシフトで最も始まるのが早いシフトを取得
        let startTime: Int = realm.objects(RealmCoopShift.self).filter("startTime>=%@", currentTime).sorted(byKeyPath: "startTime", ascending: true).map({ $0.startTime }).first!
        // 現在時刻よりも終了時刻が早いシフトで最も始まるのが遅いシフトを取得
        let endTime: Int = realm.objects(RealmCoopShift.self).filter("endTime<=%@", currentTime).sorted(byKeyPath: "startTime", ascending: false).map({ $0.startTime }).first!
        return realm.objects(RealmCoopShift.self).filter("startTime>%@ AND startTime<=%@", endTime, startTime).sorted(byKeyPath: "startTime", ascending: true)
    }
    
    public func allShiftStartTime(displayFutureShift: Bool) -> RealmSwift.Results<RealmCoopShift> {
        // 現在時刻
        let currentTime: Int = Int(Date().timeIntervalSince1970)
        // 現在時刻よりも開始時刻が遅いシフトで最も始まるのが早いシフトを取得
        let startTime: Int = realm.objects(RealmCoopShift.self).filter("startTime>=%@", currentTime).sorted(byKeyPath: "startTime", ascending: true).map({ $0.startTime }).first!

        switch displayFutureShift {
        case true:
            return realm.objects(RealmCoopShift.self).sorted(byKeyPath: "startTime", ascending: false)
        case false:
            return realm.objects(RealmCoopShift.self).filter("startTime<=%@", startTime).sorted(byKeyPath: "startTime", ascending: false)
        }
    }
    
    public func shiftNumber(displayFutureShift: Bool) -> Int {
        switch displayFutureShift {
        case true:
            let currentTime: Int = Int(Date().timeIntervalSince1970)
            // 現在時刻よりも開始時刻が遅いシフトで最も始まるのが早いシフトを取得
            return realm.objects(RealmCoopShift.self).filter("startTime>=%@", currentTime).count
        case false:
            return 0
        }
    }
    
    public func updateUserNickname(players: [PlayerMetadata]) {
        realm.beginWrite()
        for player in players {
            let account = realm.objects(RealmPlayerResult.self).filter("pid=%@", player.pid)
            account.setValue(player.name, forKey: "name")
        }
        try? realm.commitWrite()
    }

    // 最新のバイトIDを取得
    public func getLatestResultId() -> Int {
        let nsaid = manager.account.nsaid
        guard let realm = try? Realm() else { return 0 }
        let jobNum: Int? = realm.objects(RealmCoopResult.self).filter("pid=%@", nsaid).max(ofProperty: "jobId")
        if let jobNum = jobNum {
            return jobNum
        } else {
            return 0
        }
    }
    
    public func addNewRotation(from rotation: [ScheduleCoop.Response]) throws {
        realm.beginWrite()
        let rotations: [RealmCoopShift] = rotation.map{ RealmCoopShift(from: $0) }
        let _ = rotations.map{ realm.create(RealmCoopShift.self, value: $0, update: .all) }
        try? realm.commitWrite()
    }
    
    // シフトスケジュールを取得
    public func getShiftSchedule(startTime: Int) throws -> RealmCoopShift {
        guard let realm = try? Realm() else { throw APPError.realm }
        guard let schedule = realm.objects(RealmCoopShift.self).filter("startTime=%@", startTime).first else { throw APPError.realm }
        return schedule
    }

    public func getNicknames() -> [String] {
        return Array(Set(realm.objects(RealmPlayerResult.self).map{ $0.pid }))
    }
 
    // MARK: ユーザ名やサムネイルを更新し、RealmPlayerのオブジェクトを作成
    public func updateNicknameAndIcons(players: [NicknameIcons.Response.NicknameIcon]) {
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
    public func addNewNicknameAndIcons(nsaid: [String]) {
        
    }

    // MARK: 新しいリザルトを追加
    public func addNewResultsFromSplatNet2(from results: [SplatNet2.Coop.Result], _ environment: Environment.Server = .splatnet2) {
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

    // MARK: データ削除
     func eraseAllRecord() throws {
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
