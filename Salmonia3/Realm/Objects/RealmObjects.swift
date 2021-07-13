//
//  RealmObjects.swift
//  Salmonia3
//
//  Created by devonly on 2021/07/13.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift

extension RealmManager {
    class Objects {
        private static let realm: Realm = try! Realm()
        
        // MARK: RealmCoopShift
        static func shift(startTime: Int) -> RealmCoopShift {
            return realm.objects(RealmCoopShift.self)
                .filter("startTime=%@", startTime).first!
        }
        
        // MARK: RealmCoopResult
        // 全リザルトを返す
        static var results: RealmSwift.Results<RealmCoopResult> {
            return realm.objects(RealmCoopResult.self)
                .filter("pid=%@", manager.account.nsaid)
                .sorted(byKeyPath: "playTime", ascending: false)
        }
        
        // プレイヤーIDを指定
        static func results(playerId: String) -> RealmSwift.Results<RealmCoopResult> {
            return realm.objects(RealmCoopResult.self)
                .filter("pid=%@", playerId)
                .sorted(byKeyPath: "playTime", ascending: false)
        }

        // プレイヤーIDを複数指定
        static func results(playerId: [String]) -> RealmSwift.Results<RealmCoopResult> {
            return realm.objects(RealmCoopResult.self)
                .filter("pid IN", playerId)
                .sorted(byKeyPath: "playTime", ascending: false)
        }
        
        // シフトIDを指定
        static func results(startTime: Int) -> RealmSwift.Results<RealmCoopResult> {
            return realm.objects(RealmCoopResult.self)
                .filter("pid=%@ AND startTime=%@", manager.account.nsaid, startTime)
                .sorted(byKeyPath: "playTime", ascending: false)
        }
        
        // シフトIDとプレイヤーIDを指定
        static func results(startTime: Int, playerId: String) -> RealmSwift.Results<RealmCoopResult> {
            return realm.objects(RealmCoopResult.self)
                .filter("pid=%@ AND startTime=%@", playerId, startTime)
                .sorted(byKeyPath: "playTime", ascending: false)
        }

        // シフトIDとプレイヤーIDを複数指定
        static func results(startTime: Int, playerId: [String]) -> RealmSwift.Results<RealmCoopResult> {
            return realm.objects(RealmCoopResult.self)
                .filter("pid IN %@ AND startTime=%@", playerId, startTime)
                .sorted(byKeyPath: "playTime", ascending: false)
        }

        // ステージIDを指定
        static func results(stageId: Int) -> RealmSwift.Results<RealmCoopResult> {
            return realm.objects(RealmCoopResult.self)
                .filter("pid=%@ AND stageId=%@", manager.account.nsaid, stageId)
                .sorted(byKeyPath: "playTime", ascending: false)
        }
        
        // MARK: RealmCoopWave
        // 全WAVEリザルトを返す
        static var waves: RealmSwift.Results<RealmCoopWave> {
            return realm.objects(RealmCoopWave.self)
                .filter("ANY result.pid=%@", manager.account.nsaid)
                .sorted(byKeyPath: "goldenIkuraNum", ascending: false)
        }
        
        static func waves(startTime: Int) -> RealmSwift.Results<RealmCoopWave> {
            return realm.objects(RealmCoopWave.self)
                .filter("ANY result.pid=%@ AND ANY result.startTime=%@", manager.account.nsaid, startTime)
        }
        
        static func waves(stageId: Int) -> RealmSwift.Results<RealmCoopWave> {
            return realm.objects(RealmCoopWave.self)
                .filter("ANY result.pid=%@ AND ANY result.stageId=%@", manager.account.nsaid, stageId)
        }
        
        // MARK: RealmPlayerResult
        static func playerResults(playerId: String) -> RealmSwift.Results<RealmPlayerResult> {
            return realm.objects(RealmPlayerResult.self)
                .filter("pid=%@", playerId)
        }
        
        static func playerResults(startTime: Int) -> RealmSwift.Results<RealmPlayerResult> {
            return realm.objects(RealmPlayerResult.self)
                .filter("pid=%@ AND ANY result.startTime=%@", manager.playerId, startTime)
        }

        static func playerResults(startTime: Int, playerId: String) -> RealmSwift.Results<RealmPlayerResult> {
            return realm.objects(RealmPlayerResult.self)
                .filter("pid=%@ AND ANY result.startTime=%@", playerId, startTime)
        }

        static func playerResults(startTime: Int, playerId: [String]) -> RealmSwift.Results<RealmPlayerResult> {
            return realm.objects(RealmPlayerResult.self)
                .filter("pid IN %@ AND ANY result.startTime=%@", playerId, startTime)
        }

        // MARK: RealmPlayer
        // マッチングしたプレイヤーを返す
        static var players: RealmSwift.Results<RealmPlayer> {
            return realm.objects(RealmPlayer.self)
                .filter("nsaid!=%@", manager.account.nsaid)
                .sorted(byKeyPath: "lastMatchedTime", ascending: false)
        }
    }
}
