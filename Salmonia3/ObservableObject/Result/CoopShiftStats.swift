//
//  ShiftStats.swift
//  Salmonia3
//
//  Created by devonly on 2021/04/09.
//

import Foundation
import RealmSwift

final class CoopShiftStats: ObservableObject {
    @Published var resultAvg: ResultAvg?
    @Published var resultMax: ResultMax?
    @Published var overview: ResultOverView?
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
    
    private func getWeaponData(startTime: Int, nsaid: [String]) -> [ResultWeapon] {
        let shift = RealmManager.shared.realm.objects(RealmCoopShift.self).filter("startTime=%@", startTime).first!
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

    class ResultOverView {
        var jobNum: Int?
        var clearWave: Double?
        var clearRatio: Double?
        var goldenEggRatio: Double?
        var powerEggRatio: Double?
        var specialWeapon: [Double?] = []
        
        init(results: RealmSwift.Results<RealmCoopResult>, player: RealmSwift.Results<RealmPlayerResult>) {
            guard let _ = results.first else { return }
            jobNum = results.count
            clearRatio = calcRatio(results.filter("isClear=true").count, divideBy: jobNum)
            goldenEggRatio = calcRatio(player.sum(ofProperty: "goldenIkuraNum"), divideBy: results.sum(ofProperty: "goldenEggs"))
            powerEggRatio = calcRatio(player.sum(ofProperty: "ikuraNum"), divideBy: results.sum(ofProperty: "powerEggs"))
            specialWeapon = [
                calcRatio(player.filter("specialId=%@", 2).count, divideBy: jobNum),
                calcRatio(player.filter("specialId=%@", 7).count, divideBy: jobNum),
                calcRatio(player.filter("specialId=%@", 8).count, divideBy: jobNum),
                calcRatio(player.filter("specialId=%@", 9).count, divideBy: jobNum)
            ]
        }
    }
    
    class ResultWeapon: Identifiable {
        var id: String = UUID().uuidString
        var weaponId: Int
        var count: Int = 0
        var image: String {
            return String(weaponId).imageURL
        }
        
        init(weaponId: Int, count: Int) {
            self.weaponId = weaponId
            self.count = count
        }
    }
    
    class ResultMax {
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

    class ResultAvg {
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

