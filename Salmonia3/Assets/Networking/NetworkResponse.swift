//
//  NetworkResponse.swift
//  Salmonia3
//
//  Created by Devonly on 3/28/21.
//

import Foundation
import Alamofire

class SalmonStats {
    
    class UploadResult: Decodable {
        var results: [UploadResultData] = []
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            results = try container.decode([UploadResultData].self)
        }
    }
    
    class UploadResultData: Decodable {
        var salmonId: Int
        var created: Bool
        var jobId: Int
        
        private enum CodingKeys: String, CodingKey {
            case salmonId = "salmon_id"
            case created = "created"
            case jobId = "job_id"
        }

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            salmonId = try container.decode(Int.self, forKey: .salmonId)
            created = try container.decode(Bool.self, forKey: .created)
            jobId = try container.decode(Int.self, forKey: .jobId)
        }
    }
    
//    class ResultCoop: CoopResultProtocol, Decodable {
//        var jobId: Int
//        var stageId: Int
//        var jobResult: JobResult
//        var grade: Int?
//        var gradePoint: Int?
//        var startTime: String
//        var playTime: String
//        var endTime: String
//        var waveDetails: [WaveResultProtocol]
//        var dangerRate: Double
//        var bossCounts: [Int]
//        var bossKillCounts: [Int]
//        var playerResults: [PlayerResultProtocol]
//
//        private enum CodingKeys: String, CodingKey {
//            case jobId          = "id"
//            case failReasonId   = "fail_reason_id"
//            case clearWaves     = "clear_waves"
//            case createdAt      = "created_at"
//            case dangerRate     = "danger_rate"
//            case jobScore       = "job_score"
//            case jobRate        = "job_rate"
//            case jobResult      = "job_result"
//            case members        = "members"
//            case membersAccount = "member_accounts"
//            case playerResults  = "player_results"
//            case grade          = "grade"
//            case gradePoint     = "grade_point"
//            case startTime      = "schedule_id"
//            case schedule       = "schedule"
//            case playTime       = "start_at"
//            case endTime        = "end_time"
//            case waveDetails    = "waves"
//            case bossCounts     = "boss_appearances"
//        }
//
//        required init(from decoder: Decoder) throws {
//            let container = try decoder.container(keyedBy: CodingKeys.self)
//            // ISO8601用のDateformatter
//            let idfm: ISO8601DateFormatter = {
//                let formatter = ISO8601DateFormatter()
//                formatter.timeZone = TimeZone.current
//                return formatter
//            }()
//
//            // Salmon Stats用のDateformatter
//            let dfm: DateFormatter = {
//                let formatter = DateFormatter()
//                formatter.timeZone = TimeZone.current
//                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                return formatter
//            }()
//
//            jobId = try container.decode(Int.self, forKey: .jobId)
//            if let _failureReason = try? container.decode(Int.self, forKey: .failReasonId) {
//                // 失敗したとき
//                let failureWave = try container.decode(Int.self, forKey: .clearWaves)
//                let failureReason = _failureReason == 2 ? "time_limit" : "wipe_out"
//                jobResult = JobResult(failureReason: failureReason, failureWave: failureWave, isClear: true)
//            } else {
//                // クリアしたとき
//                jobResult = JobResult(failureReason: nil, failureWave: nil, isClear: true)
//            }
//            let schedule = try container.decode(Schedule.self, forKey: .schedule)
//            startTime = idfm.string(from: dfm.date(from: schedule.startTime)!)
//            endTime = idfm.string(from: dfm.date(from: schedule.endTime)!)
//            stageId = schedule.stageId + 4999
//            playTime = try container.decode(String.self, forKey: .playTime)
//            if let _dangerRate = try? container.decode(Double.self, forKey: .dangerRate) {
//                dangerRate = _dangerRate
//            } else {
//                dangerRate = Double(try container.decode(String.self, forKey: .dangerRate))!
//            }
//            bossCounts = try container.decode([Int: Int].self, forKey: .bossCounts).sorted{ $0.0 < $1.0 }.map{ $0.value }
//            waveDetails = try container.decode([WaveResult].self, forKey: .waveDetails)
//            playerResults = try container.decode([PlayerResult].self, forKey: .playerResults)
//            bossKillCounts = Array(repeating: 0, count: 9)
//
//            var _bossKillCounts: [Int] = Array(repeating: 0, count: 9)
//            for player in playerResults {
//                _bossKillCounts = Array(zip(player.bossKillCounts, _bossKillCounts)).map{ $0.0 + $0.1 }
//            }
//            bossKillCounts = _bossKillCounts
//        }
//    }
//
//    public struct WaveResult: WaveResultProtocol, Decodable {
//        var eventType: String
//        var waterLevel: String
//        var goldenIkuraNum: Int
//        var goldenIkuraPopNum: Int
//        var quotaNum: Int
//        var ikuraNum: Int
//
//        private enum CodingKeys: String, CodingKey {
//            case eventType          = "event_id"
//            case waterLevel         = "water_id"
//            case goldenIkuraNum     = "golden_egg_delivered"
//            case goldenIkuraPopNum  = "golden_egg_appearances"
//            case quotaNum           = "golden_egg_quota"
//            case ikuraNum           = "power_egg_collected"
//        }
//
//        public init(from decoder: Decoder) throws {
//            let container = try decoder.container(keyedBy: CodingKeys.self)
//
//            eventType = EventType(rawValue: try container.decode(Int.self, forKey: .eventType))!.name
//            waterLevel = WaterLevel(rawValue: try container.decode(Int.self, forKey: .waterLevel))!.name
//            goldenIkuraNum = try container.decode(Int.self, forKey: .goldenIkuraNum)
//            goldenIkuraPopNum = try container.decode(Int.self, forKey: .goldenIkuraPopNum)
//            quotaNum = try container.decode(Int.self, forKey: .quotaNum)
//            ikuraNum = try container.decode(Int.self, forKey: .ikuraNum)
//        }
//
//        enum EventType: Int, CaseIterable {
//            case noevent        = 0
//            case rush           = 6
//            case seeking        = 3
//            case griller        = 4
//            case mothership     = 5
//            case fog            = 2
//            case cohockcharge   = 1
//        }
//
//        enum WaterLevel: Int, CaseIterable {
//            case low    = 1
//            case normal = 2
//            case high   = 3
//        }
//    }
//
//    // プレイヤーリザルトの構造体
//    public struct PlayerResult: PlayerResultProtocol, Decodable {
//        var bossKillCounts: [Int]
//        var deadCount: Int
//        var helpCount: Int
//        var ikuraNum: Int
//        var goldenIkuraNum: Int
//        var specialId: Int
//        var specialCounts: [Int]
//        var weaponLists: [Int]
//        var pid: String
//
//        enum CodingKeys: String, CodingKey {
//            case bossKillCounts     = "boss_eliminations"
//            case deadCount          = "death"
//            case helpCount          = "rescue"
//            case ikuraNum           = "power_eggs"
//            case goldenIkuraNum     = "golden_eggs"
//            case specialId          = "special_id"
//            case specialCounts      = "special_uses"
//            case weaponLists        = "weapons"
//            case pid                = "player_id"
//        }
//
//        public init(from decoder: Decoder) throws {
//            let container = try decoder.container(keyedBy: CodingKeys.self)
//
//            pid = try container.decode(String.self, forKey: .pid)
//            goldenIkuraNum = try container.decode(Int.self, forKey: .goldenIkuraNum)
//            ikuraNum = try container.decode(Int.self, forKey: .ikuraNum)
//            helpCount = try container.decode(Int.self, forKey: .helpCount)
//            deadCount = try container.decode(Int.self, forKey: .deadCount)
//            specialId = try container.decode(Int.self, forKey: .specialId)
//            bossKillCounts = (try container.decode(BossEliminations.self, forKey: .bossKillCounts)).counts.sorted{ $0.0 < $1.0 }.map{ $0.value }
//            guard let _weaponLists = try container.decodeIfPresent([SSWeaponList].self, forKey: .weaponLists) else { throw APIError.invalid }
//            weaponLists = _weaponLists.map{ $0.weapon_id }
//            guard let _specialCounts = try container.decodeIfPresent([SpecialUsage].self, forKey: .specialCounts) else { throw APIError.invalid }
//            specialCounts = _specialCounts.map{ $0.count }
//        }
//    }
}

//extension SalmonStats.WaveResult.EventType {
//    var name: String {
//        switch self {
//        case .noevent:
//            return "water-levels"
//        case .rush:
//            return "rush"
//        case .seeking:
//            return "goldie-seeking"
//        case .griller:
//            return "griller"
//        case .mothership:
//            return "the-mothership"
//        case .fog:
//            return "fog"
//        case .cohockcharge:
//            return "cohock-charge"
//        }
//    }
//}
//
//extension SalmonStats.WaveResult.WaterLevel {
//    var name: String {
//        switch self {
//        case .low:
//            return "low"
//        case .normal:
//            return "normal"
//        case .high:
//            return "high"
//        }
//    }
//}
//
//extension SplatNet2.ResultCoop.StageType {
//    var stageId: Int {
//        switch self {
//        case .shakeup:
//            return 5000
//        case .shakeship:
//            return 5001
//        case .shakehouse:
//            return 5002
//        case .shakelift:
//            return 5003
//        case .shakeride:
//            return 5004
//        }
//    }
//}
