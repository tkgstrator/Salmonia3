//
//  ShiftStats.swift
//  Salmonia3
//
//  Created by devonly on 2021/04/09.
//

import Foundation
import RealmSwift

final class ShiftStats: Identifiable {
    var resultAvg: ResultAvg
    var resultMax: ResultMax
    var overview: ResultOverView

    init(startTime: Int) {
        let realm = try! Realm()
        let nsaid: [String] = Array(realm.objects(RealmUserInfo.self).map{ $0.nsaid! })
        let player = realm.objects(RealmPlayerResult.self).filter("ANY result.startTime=%@ and pid IN %@", startTime, nsaid)
        let result = realm.objects(RealmCoopResult.self).filter("startTime=%@", startTime)
        resultMax = ResultMax(player: player, result: result)
        resultAvg = ResultAvg(player: player, result: result)
        overview = ResultOverView(result: result)
    }

    class ResultOverView {
        var jobNum: Int?
        var clearWave: Double?
        var clearRatio: Double?
        var goldenEggRatio: Double?
        var powerEggRatio: Double?
        
        init(result: RealmSwift.Results<RealmCoopResult>) {
            guard let _ = result.first else { return }
            jobNum = result.count
            clearRatio = calcRatio(result.filter("isClear=true").count, divideBy: jobNum)
        }
        
        fileprivate func calcRatio(_ value: Int, divideBy: Int?) -> Double? {
            guard let divideBy = divideBy else { return nil }
            if divideBy == 0 { return nil }
            return Double(value * 10000 / divideBy) / 100
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
            helpCount = player.average(ofProperty: "helpCount")
            deadCount = player.average(ofProperty: "deadCount")
        }
    }
}
