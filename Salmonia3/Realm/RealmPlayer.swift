//
//  RealmPlayer.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/06/06.
//

import Foundation
import RealmSwift
import SalmonStats
import SplatNet2

final class RealmPlayer: Object, ObjectKeyIdentifiable {
    /// プレイヤー固有ID
    @Persisted(primaryKey: true) var nsaid: String
    /// Salmon Statsに登録したID
    @Persisted(indexed: true) var salmonId: Int?
    /// NSO登録名
    @Persisted var nickname: String
    /// NSO登録画像
    @Persisted var thumbnailURL: String
    @Persisted var jobNum: Int
    @Persisted var goldenIkuraTotal: Int
    @Persisted var helpTotal: Int
    @Persisted var ikuraTotal: Int
    @Persisted var lastMatchedTime: Int
    @Persisted var rankedCount: Int

    convenience init(from account: NicknameIcons.Response.NicknameIcon) {
        self.init()
        self.nsaid = account.nsaId
        self.nickname = account.nickname
        self.thumbnailURL = account.thumbnailUrl
        self.lastMatchedTime = RealmManager.shared.results.filter("ANY player.pid=%@", self.nsaid).sorted(byKeyPath: "playTime", ascending: false).first?.playTime ?? 0
//        self.rankedCount = RealmManager.shared.records.filter("ANY members CONTAINS %@", self.nsaid).count
    }
    
    convenience init?(from account: ExNicknameAndIcons) {
        self.init()
        self.salmonId = account.id
        self.nsaid = account.nsaId
        self.nickname = account.nickname
        guard let bundle = Bundle.main.url(forResource: "default", withExtension: "png") else { return nil }
        self.thumbnailURL = account.thumbnailUrl ?? bundle.absoluteString
        self.lastMatchedTime = RealmManager.shared.results.filter("ANY player.pid=%@", self.nsaid).sorted(byKeyPath: "playTime", ascending: false).first?.playTime ?? 0
//        self.rankedCount = RealmManager.shared.records.filter("ANY members CONTAINS %@", self.nsaid).count
    }
}

/// SplatNet2レスポンスの拡張型
struct ExNicknameAndIcons: Codable {
    let nsaId: String
    let nickname: String
    let thumbnailUrl: String?
    let id: Int?
}

extension RealmPlayer {
    /// マッチング回数
    var matching: Int {
        RealmManager.shared.results.filter("ANY player.pid=%@", self.nsaid).count
    }
    
    /// そのプレイヤーとマッチングしたリザルト
    var results: [UserCoopResult] {
        let startTime: [Int] = Array(Set(RealmManager.shared.results(playerId: self.nsaid).map{ $0.startTime })).sorted(by: >)
        return startTime.map{ UserCoopResult(startTime: $0, playerId: self.nsaid) }
    }
}
