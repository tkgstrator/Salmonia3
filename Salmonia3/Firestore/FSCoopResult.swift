//
//  FSCoopResult.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/18.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SplatNet2
import SalmonStats
import Common
import CodableDictionary
import FirebaseFirestoreSwift
import FirebaseFirestore

public struct FSCoopResult: Firecode {
    public let bossCounts: [Int]
    public let dangerRate: Decimal
    public let grade: Int?
    public let gradePoint: Int?
    public let gradePointDelta: Int?
    public let jobId: Int?
    public let jobRate: Int?
    public let jobResult: CoopResult.JobResult
    public let jobScore: Int?
    public let kumaPoint: Int?
    public let myResult: FSCoopPlayer
    public let otherResults: [FSCoopPlayer]
    public let playTime: Int
    public let salmonId: Int?
    public let startTime: Int
    public let waveDetails: [FSCoopWave]

    public init(result response: SalmonResult) {
        let result: CoopResult.Response = response.result
        let id: Int? = response.salmonId
        self.bossCounts = result.bossCounts.sortedValue()
        self.dangerRate = NSDecimalNumber(value: result.dangerRate).decimalValue
        self.grade = result.grade?.id.rawValue
        self.gradePoint = result.gradePoint
        self.gradePointDelta = result.gradePointDelta
        self.jobId = result.jobId
        self.jobRate = result.jobRate
        self.jobResult = result.jobResult
        self.jobScore = result.jobScore
        self.kumaPoint = result.kumaPoint
        self.myResult = FSCoopPlayer(player: result.myResult)
        self.otherResults = (result.otherResults ?? []).compactMap({ FSCoopPlayer(player: $0) })
        self.playTime = result.playTime
        self.salmonId = id
        self.startTime = result.startTime
        self.waveDetails = result.waveDetails.map({ FSCoopWave(wave: $0) })
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.timeZone = TimeZone(identifier: "GMT")
    return formatter
}()

let iso8601Formatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions.insert(.withFractionalSeconds)
    formatter.timeZone = TimeZone(identifier: "GMT")
    return formatter
}()

extension GradeId {
    public init?(statsValue: Int?) {
        guard let rawValue = statsValue else {
            return nil
        }
        switch rawValue {
        case 0:
            self = .intern
        case 1:
            self = .apparentice
        case 2:
            self = .parttimer
        case 3:
            self = .gogetter
        case 4:
            self = .overachiver
        case 5:
            self = .profreshional
        default:
            return nil
        }
    }
}

extension WaterId {
    public init(statsValue: Int) {
        switch statsValue {
        case 1:
            self = .low
        case 2:
            self = .normal
        case 3:
            self = .high
        default:
            self = .normal
        }
    }
}

extension EventId {
    public init(statsValue: Int) {
        switch statsValue {
        case 0:
            self = .waterLevels
        case 1:
            self = .cohockCharge
        case 2:
            self = .theMothership
        case 3:
            self = .goldieSeeking
        case 4:
            self = .griller
        case 5:
            self = .fog
        case 6:
            self = .rush
        default:
            self = .waterLevels
        }
    }
}

extension ISO8601DateFormatter {
    func unixTimeStamp(from: String) -> Int {
        return Int(date(from: from)!.timeIntervalSince1970)
    }
}

extension DateFormatter {
    func unixTimeStamp(from: String) -> Int {
        return Int(date(from: from)!.timeIntervalSince1970)
    }
}

//extension CoopResult.JobResult {
//    init(result: StatsResult.Response) {
//        self.init(
//            failureWave: result.clearWaves == 3 ? nil : result.clearWaves,
//            isClear: result.clearWaves == 3,
//            failureReason: FailureReason(rawValue: result.failReasonId)
//        )
//    }
//}

extension FailureReason {
    init?(rawValue: Int?) {
        switch rawValue {
            case 1:
                self = .wipeOut
            case 2:
                self = .timeLimit
            default:
                return nil
        }
    }
}

extension FSCoopResult {
    public var id: Int {
        playTime
    }
    
    public var reference: DocumentReference {
        Firestore
            .firestore()
            .collection(Self.path)
            .document(self.myResult.pid)
            .collection("results")
            .document("\(self.playTime)")
    }
    
    static var path: String {
        "users"
    }
}
