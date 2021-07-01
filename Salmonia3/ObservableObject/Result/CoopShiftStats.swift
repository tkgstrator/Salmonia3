//
//  ShiftStats.swift
//  Salmonia3
//
//  Created by devonly on 2021/04/09.
//

import Foundation
import RealmSwift
import SwiftUI
import SwiftChart

final class CoopShiftStats: ObservableObject {
    @Published var resultAvg: ResultAvg
    @Published var resultMax: ResultMax
    @Published var overview: ResultOverView
    @Published var weaponData: [ResultWeapon] = []
    @Published var records: CoopRecord
    private var token: NotificationToken?

    init(startTime: Int) {
        let realm = try! Realm()
        let nsaid: [String] = Array(realm.objects(RealmUserInfo.self).map{ $0.nsaid! })
        let player = realm.objects(RealmPlayerResult.self).filter("ANY result.startTime=%@ and pid IN %@", startTime, nsaid)
        let result = realm.objects(RealmCoopResult.self).filter("startTime=%@", startTime)
        
        records = CoopRecord(startTime: startTime)
        resultMax = ResultMax(player: player, result: result)
        resultAvg = ResultAvg(player: player, result: result)
        overview = ResultOverView(results: result, player: player)
        weaponData = getWeaponData(startTime: startTime, nsaid: nsaid)

        token = RealmManager.shared.realm.objects(RealmCoopResult.self).observe{ [weak self] (changes: RealmCollectionChange) in
            self!.resultMax = ResultMax(player: player, result: result)
            self!.resultAvg = ResultAvg(player: player, result: result)
            self!.overview = ResultOverView(results: result, player: player)
            self!.weaponData = self!.getWeaponData(startTime: startTime, nsaid: nsaid)
        }
    }

    deinit {
        token?.invalidate()
    }
    
    // MARK: 指定されたスケジュールのブキのリストを返す
    private func getWeaponData(startTime: Int, nsaid: [String]) -> [ResultWeapon] {
        guard let shift = RealmManager.shared.realm.objects(RealmCoopShift.self).filter("startTime=%@", startTime).first else { return [] }
        let suppliedWepons: [Int] = RealmManager.shared.realm.objects(RealmPlayerResult.self).filter("ANY result.startTime=%@ AND pid IN %@", startTime, nsaid).flatMap{ $0.weaponList }
        let allWeaponLists: [Int] = Array(WeaponType.allCases.map{ $0.rawValue })

        switch shift.weaponList.contains(-1) {
            case true:
                return allWeaponLists
                    .filter({ $0 >= 0 && $0 < 10000 || $0 == shift.rareWeapon.intValue })
                    .sorted(by: <)
                    .map({ ResultWeapon(weaponId: $0, count: suppliedWepons.count($0)) })
            case false:
                switch shift.weaponList.contains(-2) {
                case true:
                    return allWeaponLists
                        .filter({ $0 >= 20000 })
                        .sorted(by: <)
                    .map({ ResultWeapon(weaponId: $0, count: suppliedWepons.count($0)) })
                case false:
                    return shift.weaponList
                        .sorted(by: <)
                        .map({ ResultWeapon(weaponId: $0, count: suppliedWepons.count($0)) })
            }
        }
    }

    // MARK: シフト統計の大雑把な値を返す
    final class ResultOverView {
        var jobNum: Int?
        var player: RealmSwift.Results<RealmPlayerResult>?
        var clearWave: Double?
        var clearRatio: Double?
        var goldenEggRatio: Double?
        var powerEggRatio: Double?
        lazy var specialWeapon = {
            return [
                PieChartData(value: Double(self.player?.filter("specialId=%@", 2).count ?? 0), label: { Text("A") }),
                PieChartData(value: Double(self.player?.filter("specialId=%@", 7).count ?? 0), label: { Text("A") }),
                PieChartData(value: Double(self.player?.filter("specialId=%@", 8).count ?? 0), label: { Text("A") }),
                PieChartData(value: Double(self.player?.filter("specialId=%@", 9).count ?? 0), label: { Text("A") })
            ]
        }()
        var playerBossDefeatedRatio: [Double?] = []
        var otherBossDefeatedRatio: [Double?] = []
        var teamBossDefeatedRatio: [Double?] = []
        var bossAppearRatio: [Double?] = []
        
        init(results: RealmSwift.Results<RealmCoopResult>, player: RealmSwift.Results<RealmPlayerResult>) {
            guard let _ = results.first else { return }
            self.player = player
            self.jobNum = results.count
            self.clearRatio = calcRatio(results.filter("isClear=true").count, divideBy: jobNum)
            self.goldenEggRatio = calcRatio(player.sum(ofProperty: "goldenIkuraNum"), divideBy: results.sum(ofProperty: "goldenEggs"))
            self.powerEggRatio = calcRatio(player.sum(ofProperty: "ikuraNum"), divideBy: results.sum(ofProperty: "powerEggs"))
            

            // MARK: 各オオモノの出現数を保存
            let bossAppearCount = Array(results.map({ $0.bossCounts })).sum()
            let bossKillCount = Array(results.map({ $0.bossKillCounts })).sum()
            let playerBossKillCount = Array(player.map({ $0.bossKillCounts })).sum()
            let otherBossKillCount = Array(zip(bossAppearCount, playerBossKillCount).map({ $0.0 - $0.1 }))
            
            self.playerBossDefeatedRatio = bossDefeatedRatio(playerBossKillCount, bossAppearCount)
            self.teamBossDefeatedRatio = bossDefeatedRatio(bossKillCount, bossAppearCount)
            self.otherBossDefeatedRatio = bossDefeatedRatio(otherBossKillCount, bossKillCount.map({ $0 * 3}))
            let total: Int = bossAppearCount.drop(index: [0, 7]).reduce(0, +)
            self.bossAppearRatio = bossAppearCount.drop(index: [0, 7]).map({ Double($0) / Double(total) })
        }
    }

    // MARK: 出現したブキのカウントを行う
    final class ResultWeapon: Identifiable {
        var id: String = UUID().uuidString
        var weaponId: Int
        var count: Int = 0
        var image: String { String(weaponId).imageURL }
        
        init(weaponId: Int, count: Int) {
            self.weaponId = weaponId
            self.count = count
        }
    }
    
    // MARK: 最高の評価を取得
    final class ResultMax {
        var teamPowerEggs: Int?
        var teamGoldenEggs: Int?
        var powerEggs: Int?
        var goldenEggs: Int?
        var bossDefeated: Int?
        var helpCount: Int?
        var deadCount: Int?

        init(player: RealmSwift.Results<RealmPlayerResult>, result: RealmSwift.Results<RealmCoopResult>) {
            teamPowerEggs = result.max(ofProperty: "powerEggs")
            teamGoldenEggs = result.max(ofProperty: "goldenEggs")
            powerEggs = player.max(ofProperty: "ikuraNum")
            goldenEggs = player.max(ofProperty: "goldenIkuraNum")
            bossDefeated = player.map{ $0.bossKillCounts.sum() }.max()
            helpCount = player.max(ofProperty: "helpCount")
            deadCount = player.max(ofProperty: "deadCount")
        }
    }

    // MARK: 平均の評価を取得
    final class ResultAvg {
        var teamPowerEggs: Double?
        var teamGoldenEggs: Double?
        var powerEggs: Double?
        var goldenEggs: Double?
        var bossDefeated: Double?
        var helpCount: Double?
        var deadCount: Double?

        init(player: RealmSwift.Results<RealmPlayerResult>, result: RealmSwift.Results<RealmCoopResult>) {
            teamPowerEggs = result.average(ofProperty: "powerEggs")
            teamGoldenEggs = result.average(ofProperty: "goldenEggs")
            powerEggs = player.average(ofProperty: "ikuraNum")
            goldenEggs = player.average(ofProperty: "goldenIkuraNum")
            bossDefeated = player.map{ $0.bossKillCounts.sum() }.avg()
            helpCount = player.average(ofProperty: "helpCount")
            deadCount = player.average(ofProperty: "deadCount")
        }
    }
}

func calcRatio(_ value: Int, divideBy: Int?) -> Double? {
    guard let divideBy = divideBy else { return nil }
    if divideBy == 0 { return nil }
    return Double(value * 10000 / divideBy) / 100
}

fileprivate extension Array where Element == Int {
    func avg() -> Double? {
        if self.isEmpty { return nil }
        return Double(self.reduce(0, +)) / Double(self.count)
    }
    
    func average(divideBy: Int) -> Double? {
        if divideBy == 0 { return nil }
        return Double(self.reduce(0, +)) / Double(divideBy)
    }
    
    func count(_ element: Int) -> Int {
        return self.filter{ $0 == element }.count
    }
}

extension Collection where Element == RealmSwift.List<Int> {
    func sum() -> [Int] {
        guard let element = self.first else { return [] }
        
        var value: [Int] = Array(repeating: 0, count: element.count)
        for array in self {
            value = Array(zip(Array(array), value).map({ $0.0 + $0.1 }))
        }
        return value
    }
}

private func bossDefeatedRatio<T: Collection, U: FloatingPoint>(_ a: T, _ b: T) -> T where T.Element == U {
    if a.count != b.count { fatalError() }
    return Array(zip(a, b).map({ $0.0 / $0.1 })) as! T
}

private func bossDefeatedRatio(_ a: [Int], _ b: [Int] ) -> [Double] {
    if a.count != b.count { fatalError() }
    return Array(zip(a, b).map({ Double($0.0) / Double($0.1) }))
}

private extension Collection where Element == Int {
    func drop(index: [Int]) -> [Int] {
        return self.filter({ !index.contains(self.firstIndex(of: $0) as! Int) })
    }
}
