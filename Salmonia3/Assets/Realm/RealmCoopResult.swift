//
//  RealmCoopResult.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/12.
//

import Foundation
import RealmSwift

class RealmCoopResult: Object, Identifiable, Codable {
    @objc dynamic var nsaid: String?
    let jobId = RealmOptional<Int>() // SplatNet2用のID
    let stageId = RealmOptional<Int>()
    let salmonId = RealmOptional<Int>() // SalmonStats用のID
    let gradePoint = RealmOptional<Int>()
    let gradeId = RealmOptional<Int>()
    let gradePointDelta = RealmOptional<Int>()
    let failureWave = RealmOptional<Int>()
    let dangerRate = RealmOptional<Double>()
    @objc dynamic var playTime: String?
    @objc dynamic var endTime: String?
    @objc dynamic var startTime: String?
    let goldenEggs = RealmOptional<Int>()
    let powerEggs = RealmOptional<Int>()
    @objc dynamic var failureReason: String?
    @objc dynamic var isClear: Bool = false
    dynamic var bossCounts = List<Int>()
    dynamic var bossKillCounts = List<Int>()
    dynamic var wave = List<RealmCoopWave>()
    dynamic var player = List<RealmPlayerResult>()
    
    override static func primaryKey() -> String? {
        return "playTime"
    }
    
    override static func indexedProperties() -> [String] {
        return ["start_time"]
    }
    
    private enum CodingKeys: String, CodingKey {
        case nsaid
        case stageId            = "stage_id"
        case salmonId           = "salmon_id"
        case gradePoint         = "grade_point"
        case gradeId            = "grade_id"
        case gradePointDelta    = "grade_point_delta"
        case failureWave        = "failure_wave"
        case dangerRate         = "danger_rate"
        case playTime           = "play_time"
        case endTime            = "end_time"
        case startTime          = "start_time"
        case goldenEggs         = "golden_eggs"
        case powerEggs          = "power_eggs"
        case failureReason      = "failure_reason"
        case isClear            = "is_clear"
        case bossCounts         = "boss_counts"
        case bossKillCounts     = "boss_kill_counts"
    }

    required convenience public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        nsaid = try container.decode(String.self, forKey: .nsaid)
        #warning("RealmOptionalInt")
        salmonId.value = try container.decode(Int.self, forKey: .salmonId)
        stageId.value = try container.decode(Int.self, forKey: .stageId)
        gradePoint.value = try container.decode(Int.self, forKey: .gradePoint)
        gradePointDelta.value = try container.decode(Int.self, forKey: .gradePointDelta)
        gradeId.value = try container.decode(Int.self, forKey: .gradeId)
        failureWave.value = try container.decode(Int.self, forKey: .failureWave)
        dangerRate.value = try container.decode(Double.self, forKey: .dangerRate)
        goldenEggs.value = try container.decode(Int.self, forKey: .goldenEggs)
        powerEggs.value = try container.decode(Int.self, forKey: .powerEggs)
        failureReason = try container.decode(String.self, forKey: .failureReason)
        isClear = try container.decode(Bool.self, forKey: .isClear)
        powerEggs.value = try container.decode(Int.self, forKey: .stageId)
        #warning("DateFormatterを毎回呼び出すのはコストが重いかも")
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        
        let _startTime = try container.decode(Double.self, forKey: .startTime)
        startTime = dateFormatter.string(from: Date(timeIntervalSince1970: _startTime))
        let _endTime = try container.decode(Double.self, forKey: .startTime)
        endTime = dateFormatter.string(from: Date(timeIntervalSince1970: _endTime))
        let _playTime = try container.decode(Double.self, forKey: .startTime)
        playTime = dateFormatter.string(from: Date(timeIntervalSince1970: _playTime))
    }
}
