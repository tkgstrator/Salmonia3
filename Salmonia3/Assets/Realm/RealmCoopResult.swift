//
//  RealmCoopResult.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/12.
//

import Foundation
import RealmSwift

class RealmCoopResult: Object {
    @objc dynamic var nsaid: String?
    let job_id = RealmOptional<Int>() // SplatNet2用のID
    let stage_id = RealmOptional<Int>()
    let salmon_id = RealmOptional<Int>() // SalmonStats用のID
    let grade_point = RealmOptional<Int>()
    let grade_id = RealmOptional<Int>()
    let grade_point_delta = RealmOptional<Int>()
    let failure_wave = RealmOptional<Int>()
    let danger_rate = RealmOptional<Double>()
    let play_time = RealmOptional<Int>()
    @objc dynamic var end_time: Date?
    @objc dynamic var start_time: Date?
    let golden_eggs = RealmOptional<Double>()
    let power_eggs = RealmOptional<Double>()
    @objc dynamic var failure_reason: String?
    @objc dynamic var is_clear: Bool = false
    dynamic var boss_counts = List<Int>()
    dynamic var boss_kill_counts = List<Int>()
    dynamic var wave = List<RealmCoopWave>()
    dynamic var player = List<RealmPlayerResult>()
    
    override static func primaryKey() -> String? {
        return "play_time"
    }
    
    override static func indexedProperties() -> [String] {
        return ["start_time"]
    }
}
