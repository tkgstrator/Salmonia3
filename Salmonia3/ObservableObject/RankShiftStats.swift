//
//  RankShiftStats.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/06.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift
import SplatNet2
import SalmonStats
import CocoaLumberjackSwift
import Combine

final class RankShiftStats: ObservableObject {
    internal let nsaid: String?
    internal let session: SalmonStats
    
    // 仮データ
    @Published internal var records: [RankEgg] = []

    internal var task: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(startTime: Int, nsaid: String?) {
        self.nsaid = nsaid
        self.session = SalmonStats()

        // nsaidがオプショナルなら何もしない
        guard let nsaid = nsaid else {
            return
        }

        // 順位を取得するのに必要なリザルト一覧
        let results: RealmSwift.Results<RealmCoopWave> = realm.objects(RealmCoopWave.self).filter("ANY link.startTime=%@", startTime)
        session.getWaveResults(startTime: startTime)
            .flatMap(maxPublishers: .max(1), { self.getWaveResultsRank(results: results, response: $0.results) })
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    DDLogInfo("Success")
                case .failure(let error):
                    DDLogError(error)
                }
            }, receiveValue: { results in
                self.records = results
            })
            .store(in: &task)
    }
    
    func getWaveResultsRank(results: RealmSwift.Results<RealmCoopWave>, response: [ResultWave.CoopResultWave]) -> AnyPublisher<[RankEgg], SP2Error> {
        Deferred {
            Future { promise in
                var waveResults: [RankEgg] = []
                for eventType in EventKey.allCases {
                    for waterLevel in WaterKey.allCases {
                        let goldenIkuraNum: Int? = results.filter("eventType=%@ AND waterLevel=%@", eventType, waterLevel).max(ofProperty: "goldenIkuraNum")
                        if let results = response.first(where: { $0.waterLevel == waterLevel.id && $0.eventType == eventType.id })?.distribution {
                            let count: Int = results.map({ $0.count }).reduce(0, +)
                            let rank: Int? = {
                                if let goldenIkuraNum = goldenIkuraNum {
                                    return results.filter({ $0.goldenIkuraNum > goldenIkuraNum }).map({ $0.count }).reduce(1, +)
                                }
                                return nil
                            }()
                            waveResults.append(RankEgg(goldenEggs: goldenIkuraNum, rank: rank, total: count, eventType: eventType, waterLevel: waterLevel))
                        }
                    }
                }
                promise(.success(waveResults))
            }
        }
        .eraseToAnyPublisher()
    }
}


internal struct RankEgg: Identifiable {
    let goldenEggs: Int?
    let rank: Int?
    let total: Int?
    let eventType: EventKey
    let waterLevel: WaterKey
    var isValid: Bool {
        switch (eventType, waterLevel) {
        case (.rush, .low):
            return false
        case (.goldieSeeking, .low):
            return false
        case (.griller, .low):
            return false
        case (.cohockCharge, .normal):
            return false
        case (.cohockCharge, .high):
            return false
        default:
            return true
        }
    }
    
    var id: String {
        eventType.rawValue + waterLevel.rawValue
    }
}
