//
//  RealmPlayer.swift
//  Salmonia3
//
//  Created by devonly on 2021/06/06.
//

import Foundation
import RealmSwift
import SalmonStats
import SplatNet2

final class RealmPlayer: Object {
    @objc dynamic var nsaid: String?
    @objc dynamic var nickname: String?
    @objc dynamic var thumbnailURL: String?
    @objc dynamic var jobNum: Int = 0
    @objc dynamic var goldenIkuraTotal: Int = 0
    @objc dynamic var helpTotal: Int = 0
    @objc dynamic var ikuraTotal: Int = 0
    @objc dynamic var matching: Int = 0
    @objc dynamic var lastMatchedTime: Int = 0
    
    override static func primaryKey() -> String? {
        return "nsaid"
    }
    
    convenience init(from account: Response.NicknameIcons.NicknameIcon) {
        self.init()
        self.nsaid = account.nsaId
        self.nickname = account.nickname
        self.thumbnailURL = account.thumbnailUrl
        
        let results = RealmManager.shared.realm.objects(RealmPlayerResult.self).filter("pid=%@", account.nsaId)
        self.matching = results.count
        self.lastMatchedTime = RealmManager.shared.realm.objects(RealmCoopResult.self).sorted(byKeyPath: "playTime", ascending: false).filter("ANY player.pid =%@", account.nsaId).first?.playTime ?? 0
    }
}

extension RealmPlayer {
    var results: [UserCoopResult] {
        let startTime: [Int] = Array(Set(RealmManager.shared.realm.objects(RealmCoopResult.self).sorted(byKeyPath: "playTime", ascending: false).filter("ANY player.pid=%@", self.nsaid!).map{ $0.startTime }))
        return startTime.map{ UserCoopResult(startTime: $0, pid: self.nsaid!) }
    }
}
