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

final class RealmPlayer: Object, Identifiable {
    @Persisted(primaryKey: true) var nsaid: String
    @Persisted var nickname: String
    @Persisted var thumbnailURL: String
    @Persisted var jobNum: Int
    @Persisted var goldenIkuraTotal: Int
    @Persisted var helpTotal: Int
    @Persisted var ikuraTotal: Int
    @Persisted var matching: Int
    @Persisted var lastMatchedTime: Int
    
    convenience init(from account: NicknameIcons.Response.NicknameIcon) {
        self.init()
        self.nsaid = account.nsaId
        self.nickname = account.nickname
        self.thumbnailURL = account.thumbnailUrl
        
        guard let realm = try? Realm() else { return }
        let results = realm.objects(RealmPlayerResult.self).filter("pid=%@", account.nsaId)
        self.matching = results.count
        self.lastMatchedTime = realm.objects(RealmCoopResult.self).sorted(byKeyPath: "playTime", ascending: false).filter("ANY player.pid =%@", account.nsaId).first?.playTime ?? 0
    }
}

extension RealmPlayer {
    var id: UUID { UUID() } 

    var results: [UserCoopResult] {
        let startTime: [Int] = Array(Set(RealmManager.shared.results(playerId: self.nsaid).map{ $0.startTime })).sorted(by: >)
        return startTime.map{ UserCoopResult(startTime: $0, playerId: self.nsaid) }
    }
}
