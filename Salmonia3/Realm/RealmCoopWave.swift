//
//  RealmCoopWave.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/20.
//

import Foundation
import RealmSwift
import SalmonStats
import SplatNet2
import simd

final class RealmCoopWave: Object {
    @Persisted var eventType: EventKey
    @Persisted var waterLevel: WaterKey
    @Persisted(indexed: true) var goldenIkuraNum: Int
    @Persisted var goldenIkuraPopNum: Int
    @Persisted var quotaNum: Int
    @Persisted var ikuraNum: Int
    @Persisted(originProperty: "wave") private var link: LinkingObjects<RealmCoopResult>
    
    convenience init(dummy: Bool = true) {
        self.init()
        self.eventType = .goldieSeeking
        self.waterLevel = .high
        self.goldenIkuraNum = 999
        self.goldenIkuraPopNum = 999
        self.quotaNum = 25
        self.ikuraNum = Int.random(in: 0...9999)
    }
    
    convenience init(from result: FSCoopWave) {
        self.init()
        self.eventType = EventKey(id: result.eventType)
        self.waterLevel = WaterKey(id: result.waterLevel)
        self.goldenIkuraNum = result.goldenIkuraNum
        self.goldenIkuraPopNum = result.goldenIkuraPopNum
        self.quotaNum = result.quotaNum
        self.ikuraNum = result.ikuraNum
    }
    
    convenience init(from result: CoopResult.WaveDetail) {
        self.init()
        self.eventType = result.eventType.key
        self.waterLevel = result.waterLevel.key
        self.goldenIkuraNum = result.goldenIkuraNum
        self.goldenIkuraPopNum = result.goldenIkuraPopNum
        self.quotaNum = result.quotaNum
        self.ikuraNum = result.ikuraNum
    }
}

extension RealmCoopWave {
    var result: RealmCoopResult {
        self.link.first!
    }
    
    var specialUsage: [SpecialId] {
        result.specialUsage[index - 1]
    }
}

extension RealmCoopResult {
    var specialUsage: [[SpecialId]] {
        let usages: [(SpecialId, [Int])] = Array(zip(player.map({ $0.specialId }), player.map({ Array($0.specialCounts) })))
        var specialUsage: [[SpecialId]] = Array(repeating: [], count: wave.count)

        for usage in usages {
            for (index, count) in usage.1.enumerated() {
                specialUsage[index].append(contentsOf: Array(repeating: usage.0, count: count))
            }
        }
        return specialUsage.map({ $0.sorted(by: { $0.rawValue < $1.rawValue })})
    }
}

extension EventKey: PersistableEnum {}

extension EventKey {
    public init(id: EventId) {
        switch id {
        case .waterLevels:
            self = .waterLevels
        case .rush:
            self = .rush
        case .goldieSeeking:
            self = .goldieSeeking
        case .griller:
            self = .griller
        case .fog:
            self = .fog
        case .theMothership:
            self = .theMothership
        case .cohockCharge:
            self = .cohockCharge
        }
    }
    
    public var id: EventId {
        switch self {
        case .waterLevels:
            return .waterLevels
        case .rush:
            return .rush
        case .goldieSeeking:
            return .goldieSeeking
        case .griller:
            return .griller
        case .fog:
            return .fog
        case .theMothership:
            return .theMothership
        case .cohockCharge:
            return .cohockCharge
        }
    }
}

extension WaterKey: PersistableEnum {}

extension WaterKey {
    public init(id: WaterId) {
        switch id {
        case .low:
            self = .low
        case .normal:
            self = .normal
        case .high:
            self = .high
        }
    }
    
    public var id: WaterId {
        switch self {
        case .low:
            return .low
        case .normal:
            return .normal
        case .high:
            return .high
        }
    }
}

//
extension RealmCoopWave: Identifiable {
    /// 識別用のID
    var id: Int { self.hash }
}

