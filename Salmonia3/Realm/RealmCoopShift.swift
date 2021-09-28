//
//  RealmCoopShift.swift
//  Salmonia3
//
//  Created by tkgstrator on 3/14/21.
//

import Foundation
import RealmSwift
import SplatNet2

final class RealmCoopShift: Object, Identifiable, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var startTime: Int
    @Persisted var endTime: Int
    @Persisted var stageId: Int
    @Persisted var rareWeapon: Int?
    @Persisted var weaponList: List<Int>
    @Persisted var records: List<RealmStatsRecord>
    
    override init() {}
    
    init(from response: ScheduleCoop.Response) {
        super.init()
        self.startTime = response.startTime
        self.endTime = response.endTime
        self.stageId = response.stageId
        if response.weaponList.contains(-1) {
            self.rareWeapon = response.rareWeapon
        }
        self.weaponList.append(objectsIn: response.weaponList)
    }
    
    /// 支給されるブキ一覧を返す
    var weaponsList: [Int] {
        switch self.weaponList.contains(-1) {
        case true:
            // 緑ランダム編成
            return WeaponType.allCases.filter({ $0.rawValue >= 0 && $0.rawValue < 20000 }).map({ $0.rawValue }) + [rareWeapon!]
        case false:
            switch self.weaponList.contains(-2) {
            case true:
                // 黄金編成
                return WeaponType.allCases.filter({ $0.rawValue >= 20000 }).map({ $0.rawValue })
            case false:
                // 通常編成
                return Array(self.weaponList)
            }
        }
    }
}

//extension RealmCoopShift: Identifiable {
//    public var id: UUID { UUID() }
//}
