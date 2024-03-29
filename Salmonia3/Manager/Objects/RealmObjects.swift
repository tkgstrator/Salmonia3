//
//  RealmObjects.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/07/13.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift

extension RealmManager {
    /// 指定されたシフトIDのシフト情報を返す
    func shift(startTime: Int) -> RealmCoopShift {
        return realm.object(ofType: RealmCoopShift.self, forPrimaryKey: startTime)!
    }
    
    /// 指定されたプレイヤーIDが遊んだ全シフトIDを返す
    func shiftTimeList(nsaid: String) -> [Int] {
        return Array(Set(realm.objects(RealmCoopResult.self).filter("ANY player.pid=%@", nsaid).map{ $0.startTime })).sorted(by: >)
    }
    
    /// 表示すべきシフトのIDを返す
    var shiftIds: [Int] {
        switch UserDefaults.standard.FEATURE_FREE_02 {
        case true:
            return Array(realm.objects(RealmCoopShift.self).map({ $0.startTime }))
        case false:
            return Array(realm.objects(RealmCoopShift.self).filter("startTime <= %@", Int(Date().timeIntervalSince1970)).map({ $0.startTime }))
        }
    }
    
    /// 指定されたプレイヤーのリザルト一覧を返す
    func shiftResults(nsaid: String) -> [UserCoopResult] {
        return shiftTimeList(nsaid: nsaid).map({ UserCoopResult(startTime: $0, playerId: nsaid)})
    }
    
    /// グローバルのWAVEレコードをすべて返す
    var records: RealmSwift.Results<RealmStatsRecord> {
        realm.objects(RealmStatsRecord.self)
    }
    
    /// 金イクラ記錄か赤イクラ記錄かを返す
    func records(type: RecordTypeEgg) -> RealmSwift.Results<RealmStatsRecord> {
        realm.objects(RealmStatsRecord.self).filter("recordTypeEgg=%@", type.rawValue)
    }
    
    /// 現在のプレイヤーのリザルトを全件返す
    var results: RealmSwift.Results<RealmCoopResult> {
        return realm.objects(RealmCoopResult.self)
            .filter("pid=%@", manager.account.nsaid)
            .sorted(byKeyPath: "playTime", ascending: false)
    }

    /// 全プレイヤーのリザルトを全件返す
    var allResults: RealmSwift.Results<RealmCoopResult> {
        return realm.objects(RealmCoopResult.self)
            .sorted(byKeyPath: "playTime", ascending: false)
    }
    
    func result(playTime: Int) -> RealmCoopResult {
        realm.object(ofType: RealmCoopResult.self, forPrimaryKey: playTime)!
    }
    
    /// 指定されたプレイヤーIDのリザルトを全件返す
    func results(playerId: String) -> RealmSwift.Results<RealmCoopResult> {
        return realm.objects(RealmCoopResult.self)
            .filter("pid=%@", playerId)
            .sorted(byKeyPath: "playTime", ascending: false)
    }
    
    /// 指定されたプレイヤーIDのリザルトを全件返す
    func results(playerId: [String]) -> RealmSwift.Results<RealmCoopResult> {
        return realm.objects(RealmCoopResult.self)
            .filter("pid IN", playerId)
            .sorted(byKeyPath: "playTime", ascending: false)
    }
    
    /// 指定されたシフトIDのリザルトを全件返す
    func results(startTime: Int) -> RealmSwift.Results<RealmCoopResult> {
        return realm.objects(RealmCoopResult.self)
            .filter("pid=%@ AND startTime=%@", manager.account.nsaid, startTime)
            .sorted(byKeyPath: "playTime", ascending: false)
    }
    
    /// シフトIDとプレイヤーIDを指定してリザルトを全件返す
    func results(startTime: Int, playerId: String) -> RealmSwift.Results<RealmCoopResult> {
        return realm.objects(RealmCoopResult.self)
            .filter("pid=%@ AND startTime=%@", playerId, startTime)
            .sorted(byKeyPath: "playTime", ascending: false)
    }
    
    /// シフトIDとメンバーIDを指定してリザルトを全件返す
    func results(startTime: Int, memberId: String) -> RealmSwift.Results<RealmCoopResult> {
        return realm.objects(RealmCoopResult.self)
            .filter("ANY player.pid=%@ AND startTime=%@", memberId, startTime)
            .sorted(byKeyPath: "playTime", ascending: false)
    }
    
    /// シフトIDとプレイヤーIDを指定してリザルトを全件返す
    func results(startTime: Int, playerId: [String]) -> RealmSwift.Results<RealmCoopResult> {
        return realm.objects(RealmCoopResult.self)
            .filter("pid IN %@ AND startTime=%@", playerId, startTime)
            .sorted(byKeyPath: "playTime", ascending: false)
    }
    
    /// ステージIDを指定してリザルトを全件返す
    func results(stageId: Int) -> RealmSwift.Results<RealmCoopResult> {
        return realm.objects(RealmCoopResult.self)
            .filter("pid=%@ AND stageId=%@", manager.account.nsaid, stageId)
            .sorted(byKeyPath: "playTime", ascending: false)
    }
    
    /// 全プレイヤーのリザルトを全件返す
    func allResults(stageId: Int) -> RealmSwift.Results<RealmCoopResult> {
        return realm.objects(RealmCoopResult.self)
            .filter("stageId=%@", stageId)
            .sorted(byKeyPath: "playTime", ascending: false)
    }
    
    /// WAVEリザルトを全件返す
    var waves: RealmSwift.Results<RealmCoopWave> {
        return realm.objects(RealmCoopWave.self)
            .sorted(byKeyPath: "goldenIkuraNum", ascending: false)
    }
    
    /// シフトIDを指定してWAVEリザルトを全件返す
    func waves(startTime: Int) -> RealmSwift.Results<RealmCoopWave> {
        return realm.objects(RealmCoopWave.self)
            .filter("ANY result.pid=%@ AND ANY result.startTime=%@", manager.account.nsaid, startTime)
    }
    
    /// ステージIDを指定してWAVEリザルトを全件返す
    func waves(stageId: Int) -> RealmSwift.Results<RealmCoopWave> {
        return realm.objects(RealmCoopWave.self)
            .filter("ANY result.pid=%@ AND ANY result.stageId=%@", manager.account.nsaid, stageId)
    }

    /// ステージIDを指定して全プレイヤーのWAVEリザルトを全件返す
    func allWaves(stageId: Int) -> RealmSwift.Results<RealmCoopWave> {
        return realm.objects(RealmCoopWave.self)
            .filter("ANY result.stageId=%@", stageId)
    }

    /// プレイヤーIDを指定してプレイヤーリザルトを全件返す
    func playerResults(playerId: String) -> RealmSwift.Results<RealmPlayerResult> {
        return realm.objects(RealmPlayerResult.self)
            .filter("pid=%@", playerId)
    }
    
    /// シフトIDを指定してプレイヤーリザルトを全件返す
    func playerResults(startTime: Int) -> RealmSwift.Results<RealmPlayerResult> {
        return realm.objects(RealmPlayerResult.self)
            .filter("pid=%@ AND ANY result.startTime=%@", manager.playerId, startTime)
    }
    
    /// シフトIDとプレイヤーIDを指定してプレイヤーリザルトを全件返す
    func playerResults(startTime: Int, playerId: String) -> RealmSwift.Results<RealmPlayerResult> {
        return realm.objects(RealmPlayerResult.self)
            .filter("pid=%@ AND ANY result.startTime=%@", playerId, startTime)
    }
    
    /// シフトIDとプレイヤーIDを指定してプレイヤーリザルトを全件返す
    func playerResults(startTime: Int, playerId: [String]) -> RealmSwift.Results<RealmPlayerResult> {
        return realm.objects(RealmPlayerResult.self)
            .filter("pid IN %@ AND ANY result.startTime=%@", playerId, startTime)
    }
    
    /// 全アカウントのマッチングしたプレイヤーを全件返す
    var players: RealmSwift.Results<RealmPlayer> {
        return realm.objects(RealmPlayer.self)
            .filter("nsaid!=%@", manager.account.nsaid)
            .sorted(byKeyPath: "lastMatchedTime", ascending: false)
    }
    
    /// 指定されたプレイヤーIDのプレイヤー情報を返す
    func findPlayers(pid: [String]) -> RealmSwift.Results<RealmPlayer> {
        return realm.objects(RealmPlayer.self)
            .filter("nsaid IN %@", pid)
    }
    
    func players(startTime: Int) -> [String] {
        return Array(Set(realm.objects(RealmCoopResult.self)
            .filter("startTime=%@", startTime)
            .flatMap({ Array($0.player.compactMap({ $0.pid })) })))
    }
    
    func thumbnailURL(playerId: String) -> URL {
        guard let thumbnailURL = realm.objects(RealmPlayer.self)
                .filter("nsaid=%@", playerId)
                .first?
                .thumbnailURL else { return Bundle.main.url(forResource: "default", withExtension: "png")! }
        return URL(string: thumbnailURL)!
    }
    
    func suppliedSpecial(startTime: Int) -> [(Int, Int)] {
        let specialWeapons: [Int] = RealmManager.shared.playerResults(startTime: startTime).map({ $0.specialId })
        return SpecialType.allCases.filter({ $0.rawValue >= 0 }).map({ ($0.rawValue, specialWeapons.count($0.rawValue)) })
    }
}

extension RealmSwift.Results where Element == RealmCoopWave {
    /// WAVEリザルトから指定された潮位とイベントでの最高納品数を返す
    func maxGoldenEggs(eventType: EventType, waterLevel: WaterLevel) -> Int? {
        self.filter("eventType=%@ AND waterLevel=%@", eventType.rawValue, waterLevel.rawValue).max(ofProperty: "goldenIkuraNum")
    }
}

extension RealmSwift.Results where Element == RealmCoopResult {
    /// 評価レートが999に到達した回数を返す
    var counterStepNum: Int {
        Set(self.filter("gradePoint == 999").map({ $0.startTime })).count
    }
    
    /// 評価レートが999に到達した最短バイト回数を返す
    var minimumStepNum: Int? {
        // プレイしたシフトIDを抽出
        let startTime: [Int] = Array(Set(self.map({ $0.startTime })))
            .map({ self.filter("startTime=%@", $0) })
            .filter({ !$0.filter("gradePoint<=420").isEmpty && !$0.filter("gradePoint==999").isEmpty })
            .compactMap({ $0.first?.startTime })
        return startTime.compactMap({ element -> Int? in
            if let minimumPlayTime: Int = self.filter("startTime=%@ AND gradePoint==999", element).min(ofProperty: "playTime") {
                let count = self.filter("startTime=%@ AND playTime<=%@", element, minimumPlayTime).count
                if count < 30 { return nil } else { return count }
            }
            return nil
        }).min()
    }
}
