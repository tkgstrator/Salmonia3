//
//  RealmCoopShift.swift
//  Salmonia3
//
//  Created by devonly on 2021/11/24.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift
import SplatNet2

final class RealmCoopShift: Object {
    @Persisted var stageId: StageId
    @Persisted(primaryKey: true) var startTime: Int
    @Persisted var endTime: Int
    @Persisted var weaponList: List<WeaponType>
    @Persisted var rareWeapon: WeaponType?
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
    
    var shiftType: ShiftType {
        if weaponList.allSatisfy({ $0 == .randomGreen }) {
            return .allRandom
        }
        if weaponList.allSatisfy({ $0 == .randomGold }) {
            return .goldRandom
        }
        
        if weaponList.contains(.randomGreen) {
            return .oneRandom
        }
        return .normal
    }
}


extension RealmCoopShift: Identifiable {
    var id: Int { startTime }
}

extension WeaponType: PersistableEnum {}

extension StageId: PersistableEnum {}
