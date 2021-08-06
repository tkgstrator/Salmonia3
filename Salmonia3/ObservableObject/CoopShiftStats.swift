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
    @Published var resultAvg: ResultAvg = ResultAvg()
    @Published var resultMax: ResultMax = ResultMax()
    @Published var overview: ResultOverView = ResultOverView()
    @Published var weaponData: [ResultWeapon] = []
    @Published var records: CoopRecord = CoopRecord()
    @Published var resultWave: [ResultWave] = []
    private var token: NotificationToken?

    init(startTime: Int) {
        // 現在時刻よりもあとのやつはデータが空なのでスキップ
        if startTime >= Int(Date().timeIntervalSince1970) { return }
        // 表示するプレイヤーIDを選択
        let playerId: [String] = [manager.account.nsaid]
        // 指定されたシフトIDでのデータを取得
        // 個人記録・全体記録・WAVE記録
        let playerResults = RealmManager.Objects.playerResults(startTime: startTime, playerId: playerId)
        let results = RealmManager.Objects.results(startTime: startTime, playerId: playerId)
        let waves = RealmManager.Objects.waves(startTime: startTime)
        
        self.records = CoopRecord(startTime: startTime)
        //        self.resultMax = ResultMax(player: playerResults, result: results)
        //        self.resultAvg = ResultAvg(player: playerResults, result: results)
        //        self.overview = ResultOverView(results: results, player: playerResults)
        //        self.weaponData = self.getWeaponData(startTime: startTime, nsaid: playerId)
        self.resultWave = waves.resultWaves
        
        self.token = RealmManager.Objects.results.observe{ [weak self] _ in
            self?.resultMax = ResultMax(player: playerResults, result: results)
            self?.resultAvg = ResultAvg(player: playerResults, result: results)
            self?.overview = ResultOverView(results: results, player: playerResults)
            self?.weaponData = self!.getWeaponData(startTime: startTime, nsaid: playerId)
        }
    }

    deinit {
        token?.invalidate()
    }
    
    // MARK: 指定されたスケジュールのブキのリストを返す
    private func getWeaponData(startTime: Int, nsaid: [String]) -> [ResultWeapon] {
        let shift: RealmCoopShift = RealmManager.Objects.shift(startTime: startTime)
        let suppliedWepons: [Int] = RealmManager.Objects.playerResults(startTime: startTime).flatMap{ $0.weaponList }
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
                PieChartData(value: Double(self.player?.filter("specialId=%@", 2).count ?? 0), label: { AnyView(Image(SpecialType.init(rawValue: 2)!.image).resizable().frame(width: 35, height: 35, alignment: .center)) }),
                PieChartData(value: Double(self.player?.filter("specialId=%@", 7).count ?? 0), label: { AnyView(Image(SpecialType.init(rawValue: 7)!.image).resizable().frame(width: 35, height: 35, alignment: .center)) }),
                PieChartData(value: Double(self.player?.filter("specialId=%@", 8).count ?? 0), label: { AnyView(Image(SpecialType.init(rawValue: 8)!.image).resizable().frame(width: 35, height: 35, alignment: .center)) }),
                PieChartData(value: Double(self.player?.filter("specialId=%@", 9).count ?? 0), label: { AnyView(Image(SpecialType.init(rawValue: 9)!.image).resizable().frame(width: 35, height: 35, alignment: .center)) })
            ]
        }()
        var playerBossDefeatedRatio: [Double?] = []
        var otherBossDefeatedRatio: [Double?] = []
        var teamBossDefeatedRatio: [Double?] = []
        var bossAppearRatio: [Double?] = []
        
        init() {}
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

        init() {}
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

        init() {}
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
    
    // MARK: 各潮位とイベントにおける納品数を計算する
    final class ResultWave: Identifiable {
        var id: UUID { UUID() }
        var goldenEggs: Double?
        var count: Int?
        var tide: Int
        var event: Int
        
        init(tide: Int, event: Int, count: Int, goldenEggs: Double?) {
            self.tide = tide
            self.event = event
            self.count = count
            self.goldenEggs = goldenEggs
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

extension RealmSwift.Results where Element == RealmCoopWave {
    var resultWaves: [CoopShiftStats.ResultWave] {
        var waves: [CoopShiftStats.ResultWave] = []
        for event in EventType.allCases {
            for tide in WaterLevel.allCases {
                let results = self.filter("eventType=%@ AND waterLevel=%@", event.eventType, tide.waterLevel)
                let count: Int = results.count
                let goldenEggs: Double? = results.average(ofProperty: "goldenIkuraNum")
                waves.append(CoopShiftStats.ResultWave(tide: tide.rawValue, event: event.rawValue, count: count, goldenEggs: goldenEggs))
            }
        }
        return waves
    }
}
