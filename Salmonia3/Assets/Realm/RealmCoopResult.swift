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
    
    var specialUsage: [[Int]] {
        var usage: [[Int]] = []
        for wave in Range(0...2) {
            var tmp: [Int] = []
            for player in self.player {
                tmp += [Int](repeating: player.specialId, count: player.specialCounts[wave])
            }
            usage.append(tmp)
        }
        return usage
    }
    
    private enum CodingKeys: String, CodingKey {
        case pid                = "pid"
        case jobId              = "job_id"
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
        case otherResults       = "other_results"
        case myResult           = "my_result"
        case jobScore           = "job_score"
        case kumaPoint          = "kuma_point"
        case jobResult          = "job_result"
        case grade              = "grade"
        case schedule           = "schedule"
    }

    required convenience public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        #warning("そのままデータが使えるところ")
        gradePoint.value = try container.decode(Int.self, forKey: .gradePoint)
        gradePointDelta.value = try container.decode(Int.self, forKey: .gradePointDelta)
        dangerRate.value = try container.decode(Double.self, forKey: .dangerRate)
        jobScore.value = try container.decode(Int.self, forKey: .jobScore)
        kumaPoint.value = try container.decode(Int.self, forKey: .kumaPoint)
        
        #warning("データ整形に処理が必要なところ")
        pid = try? container.decode(String.self, forKey: .pid)
        jobId.value = try? container.decode(Int.self, forKey: .jobId)
        salmonId.value = try? container.decode(Int.self, forKey: .salmonId)
//        stageId.value = try? container.decode(Int.self, forKey: .stageId)

        let stage = try container.decode(Schedule.self, forKey: .schedule)
        stageId.value = stage.id

        #warning("バイトの結果の取得")
        let jobResult = try container.decode(JobResult.self, forKey: .jobResult)
        failureReason = jobResult.failure_reason
        failureWave.value = jobResult.failure_wave
        isClear = jobResult.is_clear
        
        #warning("ランクの取得")
        let grade = try container.decode(Grade.self, forKey: .grade)
        gradeId.value = Int(grade.id) ?? 0
        
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
        let myResult = try container.decodeIfPresent(RealmPlayerResult.self, forKey: .myResult) ?? RealmPlayerResult()
        player.append(myResult)
        
        let otherResults = try container.decodeIfPresent([RealmPlayerResult].self, forKey: .otherResults) ?? [RealmPlayerResult()]
        player.append(objectsIn: otherResults)
        
        // List型に対する処理
        let _bossKillCounts = try container.decodeIfPresent([Int: BossKillCounts].self, forKey: .bossKillCounts) ?? [Int(): BossKillCounts()]
        bossKillCounts.append(objectsIn: _bossKillCounts.sorted{ $0.0 < $1.0 }.map{ $0.value.count })

        let _bossCounts = try container.decodeIfPresent([Int: BossKillCounts].self, forKey: .bossCounts) ?? [Int(): BossKillCounts()]
        bossCounts.append(objectsIn: _bossCounts.sorted{ $0.0 < $1.0 }.map{ $0.value.count })

        let _wave = try container.decodeIfPresent([RealmCoopWave].self, forKey: .wave) ?? [RealmCoopWave()]
        wave.append(objectsIn: _wave)
        
        #warning("JSONには入っていないデータは自身から計算する")
        goldenEggs.value = wave.sum(ofProperty: "goldenIkuraNum")
        powerEggs.value = wave.sum(ofProperty: "ikuraNum")
        
    }
    
}

#warning("定義用の構造体")
private struct JobResult: Codable {
    var failure_reason: String?
    var failure_wave: Int?
    var is_clear: Bool = false
}

private struct Grade: Codable {
    var id: String = "0"
    var long_name: String = ""
    var short_name: String = ""
    var name: String = ""
}

private struct Schedule: Codable {
    var end_time: Int = 0
    var start_time: Int = 0
    var stage: [String: String] = [:]
    var id: Int? {
        guard let stageURL: String = self.stage["image"] else { return nil }
        if stageURL.contains("65c68c6f0641cc5654434b78a6f10b0ad32ccdee") { return 5000 }
        if stageURL.contains("e07d73b7d9f0c64e552b34a2e6c29b8564c63388") { return 5001 }
        if stageURL.contains("6d68f5baa75f3a94e5e9bfb89b82e7377e3ecd2c") { return 5002 }
        if stageURL.contains("e9f7c7b35e6d46778cd3cbc0d89bd7e1bc3be493") { return 5003 }
        if stageURL.contains("50064ec6e97aac91e70df5fc2cfecf61ad8615fd") { return 5004 }
        return nil
    }
}
