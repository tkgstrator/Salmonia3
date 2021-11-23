//
//  RealmCoopPlayer.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/20.
//

import Foundation
import Foundation
import RealmSwift
import SalmonStats
import SplatNet2

final class RealmCoopPlayer: Object, ObjectKeyIdentifiable {
    @Persisted var name: String?
    @Persisted(indexed: true) var pid: String
    @Persisted var deadCount: Int
    @Persisted var helpCount: Int
    @Persisted var goldenIkuraNum: Int
    @Persisted var ikuraNum: Int
    @Persisted var specialId: Result.SpecialId
    @Persisted var bossKillCounts: List<Int>
    @Persisted var weaponList: List<WeaponType.WeaponId>
    @Persisted var specialCounts: List<Int>
    @Persisted(originProperty: "player") var result: LinkingObjects<RealmCoopResult>

    public convenience init(from result: Result.PlayerResult) {
        self.init()
        self.name = result.name
        self.pid = result.pid
        self.deadCount = result.deadCount
        self.helpCount = result.helpCount
        self.goldenIkuraNum = result.goldenIkuraNum
        self.ikuraNum = result.ikuraNum
        self.specialId = result.special.id
        self.bossKillCounts.append(objectsIn: result.bossKillCounts.map({ $0.value.count }))
        self.weaponList.append(objectsIn: result.weaponList.map({ $0.id }))
        self.specialCounts.append(objectsIn: result.specialCounts)
    }
}

extension Result.SpecialId: PersistableEnum {
}

extension WeaponType.WeaponId: PersistableEnum {
}

extension RealmCoopPlayer {
    /// Nintendo Switch Onlineの画像
//    var thumbnailURL: URL {
//        RealmManager.shared.thumbnailURL(playerId: self.pid)
//    }
    
    /// 自身が操作したプレイヤーかどうかのフラグ
    var isFirstPlayer: Bool {
        guard let firstPlayer = self.result.first?.player.first else { return false }
        return firstPlayer.pid == self.pid
    }
}

extension RealmCoopPlayer: Identifiable {
    var id: String { self.pid }
}
