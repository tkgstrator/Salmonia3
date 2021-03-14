//
//  RealmCoopResult.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/12.
//

import Foundation
import RealmSwift

class RealmCoopResult: Object, Identifiable, Decodable {
    @objc dynamic var pid: String?
    let jobId = RealmOptional<Int>() // SplatNet2用のID
    let stageId = RealmOptional<Int>()
    let salmonId = RealmOptional<Int>() // SalmonStats用のID
    let gradePoint = RealmOptional<Int>()
    let gradeId = RealmOptional<Int>()
    let gradePointDelta = RealmOptional<Int>()
    let failureWave = RealmOptional<Int>()
    let jobScore = RealmOptional<Int>()
    let kumaPoint = RealmOptional<Int>()
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
    var wave = List<RealmCoopWave>()
    var player = List<RealmPlayerResult>()
    
    override static func primaryKey() -> String? {
        return "playTime"
    }
    
    override static func indexedProperties() -> [String] {
        return ["startTime"]
    }
    
    private enum CodingKeys: String, CodingKey {
        case pid              = "pid"
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
        case wave               = "wave_details"
        case player             = "other_results"
        case jobScore           = "job_score"
        case kumaPoint          = "kuma_point"
    }

    required convenience public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        pid = try? container.decode(String.self, forKey: .pid)
        #warning("RealmOptionalInt")
        salmonId.value = try? container.decode(Int.self, forKey: .salmonId)
        stageId.value = try? container.decode(Int.self, forKey: .stageId)
        gradePoint.value = try container.decode(Int.self, forKey: .gradePoint)
        gradePointDelta.value = try container.decode(Int.self, forKey: .gradePointDelta)
        dangerRate.value = try container.decode(Double.self, forKey: .dangerRate)
        goldenEggs.value = try? container.decode(Int.self, forKey: .goldenEggs)
        powerEggs.value = try? container.decode(Int.self, forKey: .powerEggs)
        gradeId.value = try? container.decode(Int.self, forKey: .gradeId)
        failureReason = try? container.decode(String.self, forKey: .failureReason)
        failureWave.value = try? container.decode(Int.self, forKey: .failureWave)
        isClear = (try? container.decode(Bool.self, forKey: .isClear)) ?? true
        #warning("DateFormatterを毎回呼び出すのはコストが重いかも")
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        
        let _startTime = try container.decode(Double.self, forKey: .startTime)
        startTime = dateFormatter.string(from: Date(timeIntervalSince1970: _startTime))
        let _endTime = try container.decode(Double.self, forKey: .endTime)
        endTime = dateFormatter.string(from: Date(timeIntervalSince1970: _endTime))
        let _playTime = try container.decode(Double.self, forKey: .playTime)
        playTime = dateFormatter.string(from: Date(timeIntervalSince1970: _playTime))
        
        // RealmSwfit.Listの書き込み
        let _player = try container.decodeIfPresent([RealmPlayerResult].self, forKey: .player) ?? [RealmPlayerResult()]
        player.append(objectsIn: _player)
        let _wave = try container.decodeIfPresent([RealmCoopWave].self, forKey: .wave) ?? [RealmCoopWave()]
        wave.append(objectsIn: _wave)

    }
}
