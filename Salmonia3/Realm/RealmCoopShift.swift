//
//  RealmCoopShift.swift
//  Salmonia3
//
//  Created by devonly on 2021/11/24.
//  
//

import Foundation
import RealmSwift
import SplatNet2

final class RealmCoopShift: Object {
    @Persisted var stageId: Schedule.StageId
    @Persisted(primaryKey: true) var startTime: Int
    @Persisted var endTime: Int
    @Persisted var weaponList: List<WeaponType>
    @Persisted var rareWeapon: WeaponType?
    @Persisted var waves: List<RealmStatsWave>
    @Persisted var total: List<RealmStatsTotal>
    @Persisted var results: List<RealmCoopResult>
    
    convenience init(from schedule: Schedule.Response) {
        self.init()
        self.stageId = schedule.stageId
        self.startTime = schedule.startTime
        self.endTime = schedule.endTime
        self.weaponList.append(objectsIn: schedule.weaponList)
        self.rareWeapon = schedule.rareWeapon
    }
}

extension RealmCoopShift {
    var stageName: String {
        switch self.stageId {
            case .shakeup:
                return "Spawning Ground"
            case .shakeship:
                return "Marroner's Bay"
            case .shakehouse:
                return "Lost Outpost"
            case .shakelift:
                return "Salmonid Smokeyard"
            case .shakeride:
                return "Ruins of Ark Polaris"
        }
    }
}

extension RealmCoopShift: Identifiable {
    var id: Int { startTime }
}

extension WeaponType: PersistableEnum {
}

extension Schedule.StageId: PersistableEnum {
}
