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
        return realm.objects(RealmCoopShift.self)
            .filter("startTime=%@", startTime).first!
    }
    
    /// 指定されたプレイヤーIDが遊んだ全シフトIDを返す
    func shiftTimeList(nsaid: String) -> [Int] {
        return Array(Set(realm.objects(RealmCoopResult.self).filter("ANY player.pid=%@", nsaid).map{ $0.startTime })).sorted(by: >)
    }
    
    func shiftResults(nsaid: String) -> [UserCoopResult] {
        return shiftTimeList(nsaid: nsaid).map({ UserCoopResult(startTime: $0, playerId: nsaid)})
    }
    
    /// リザルトを全件返す
    var results: RealmSwift.Results<RealmCoopResult> {
        return realm.objects(RealmCoopResult.self)
            .filter("pid=%@", manager.account.nsaid)
            .sorted(byKeyPath: "playTime", ascending: false)
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
    
    /// WAVEリザルトを全件返す
    var waves: RealmSwift.Results<RealmCoopWave> {
        return realm.objects(RealmCoopWave.self)
            .filter("ANY result.pid=%@", manager.account.nsaid)
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
}

extension RealmSwift.Results where Element == RealmCoopWave {
    /// WAVEリザルトから指定された潮位とイベントでの最高納品数を返す
    func maxGoldenEggs(eventType: EventType, waterLevel: WaterLevel) -> Int? {
        self.filter("eventType=%@ AND waterLevel=%@", eventType.eventType, waterLevel.waterLevel).max(ofProperty: "goldenIkuraNum")
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
