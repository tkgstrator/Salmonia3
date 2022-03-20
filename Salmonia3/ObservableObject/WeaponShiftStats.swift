//
//  WeaponShiftStats.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/06.
//

import Foundation
import RealmSwift
import SplatNet2

final class WeaponShiftStats: ObservableObject {
    internal let realm: Realm
    internal let nsaid: String?
    internal let schemeVersion: UInt64 = 8192
    
    internal var suppliedWeaponList: [WeaponStats] = []
    internal var unSuppliedWeaponList: [WeaponStats] = []
    internal var jobCount: Int = 0
    internal var completedJobCount: Int? = nil
    internal var estimateCompleteJobCount: Int = 0
    
    init(schedule: RealmCoopShift, nsaid: String?) {
        do {
            self.realm = try Realm()
            self.nsaid = nsaid
        } catch {
            var config = Realm.Configuration.defaultConfiguration
            config.deleteRealmIfMigrationNeeded = true
            config.schemaVersion = schemeVersion
            self.realm = try! Realm(configuration: config, queue: nil)
            self.nsaid = nsaid
        }
        
        // nsaidがオプショナルなら何もしない
        guard let nsaid = nsaid else {
            return
        }
        /// プレイヤーのリザルト一覧
        let results = realm.objects(RealmCoopPlayer.self).filter("ANY link.startTime=%@ AND pid=%@", schedule.startTime, nsaid)
        /// 支給されたブキ一覧
        let suppliedWeapons: [WeaponType] = results.flatMap({ Array($0.weaponList) })
        /// ブキ支給回数
        let total: Int = suppliedWeapons.count
        /// 支給されたブキのカウント
        let suppliedWeaponsCount: [(weaponType: WeaponType, count: Int)] = WeaponType.suppliedCount(supplied: suppliedWeapons, rareWeapon: schedule.rareWeapon)
        self.jobCount = results.count
        self.suppliedWeaponList = suppliedWeaponsCount.filter({ $0.count != 0 }).map({ WeaponStats(data: $0, total: total)})
        self.unSuppliedWeaponList = suppliedWeaponsCount.filter({ $0.count == 0 }).map({ WeaponStats(data: $0, total: total)})
        
        let estimateRemaindWaveCount: Double = Range(suppliedWeaponList.count ... 49).map({ Double(50) / Double(50 - $0) }).reduce(0, +)
        let estimateProbability: Double = Double(schedule.weaponList.filter({ $0 == .randomGreen }).count) * 0.8 * 3 * 0.25
        if !estimateProbability.isZero {
            self.estimateCompleteJobCount = jobCount + Int(estimateRemaindWaveCount / estimateProbability)
        }
    }
}

extension WeaponType {
    static func suppliedCount(supplied: [WeaponType], rareWeapon: WeaponType?) -> [(weaponType: WeaponType, count: Int)] {
        let suppliableWeapons = WeaponType.allCases.filter({ $0.id >= 0 && $0.id < 20000 }) + [rareWeapon].compactMap({ $0 })
        return suppliableWeapons.map({ weaponType in (weaponType: weaponType, count: supplied.filter({ $0 == weaponType }).count) })
    }
}

internal struct WeaponStats: Identifiable {
    let weaponType: WeaponType
    let suppliedCount: Int
    let suppliedProb: Double
    var id: Int {
        weaponType.id
    }
    
    init(data: (weaponType: WeaponType, count: Int), total: Int) {
        self.weaponType = data.weaponType
        self.suppliedCount = data.count
        self.suppliedProb = total != .zero ? Double(data.count) / Double(total) : .zero
    }
}
