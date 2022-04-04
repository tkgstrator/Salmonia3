//
//  UserShiftStats+Firebase.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/02.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CocoaLumberjackSwift
import Combine
import RealmSwift
import SplatNet2
import Surge

struct RankingStats {
    /// 値
    let value: Double?
    /// 平均
    let means: Double
    /// 分散
    let vars: Double
    /// 標準偏差
    let stds: Double
    /// 順位
    let rank: Int?
    /// リザルト件数
    let count: Int
    /// 確率
    let sigma: Double
    
    init(values: [Double], value: Double?) {
        self.value = value
        self.means = mean(values)
        self.vars = variance(values)
        self.stds = std(values)
        self.rank = {
            if let value = value {
                return values.filter({ $0 >= value }).count
            }
            return nil
        }()
        self.count = values.count
        self.sigma = .zero
    }
}

extension UserShiftStats {
//    func getWaveRanking(nsaid: String, eventType: EventKey, waterLevel: WaterKey, startTime: Int) -> RankingStats {
//        /// 指定されたユーザ名と潮位とイベントとシフトのリザルトを全件取得
//        let results: RealmSwift.Results<RealmStatsWave> = realm
//            .objects(RealmStatsWave.self)
//            .filter("eventType=%@ AND waterLevel=%@ AND ANY link.startTime=%@", eventType, waterLevel, startTime)
//        /// アップロードされていないとリザルトはないことになるので注意
//        /// メンバーに自分が含まれているリザルトの最高値を取得
//        let value: Double? = results.filter("members CONTAINS %@", nsaid).map({ Double($0.goldenIkuraNum) }).max()
//        /// 全体
//        let values: [Double] = realm
//            .objects(RealmStatsWave.self)
//            .filter("eventType=%@ AND waterLevel=%@ AND startTime=%@", eventType, waterLevel, startTime)
//            .map({ Double($0.goldenIkuraNum) }).sorted(by: { $0 > $1 })
//        return RankingStats(values: values, value: value)
//    }
    
    /// WAVE記録読み込み
//    func waves(startTime: Int) {
//        objects(FSCoopWave.self, startTime: startTime)
//            .sink(receiveCompletion: { completion in
//            }, receiveValue: { [self] response in
//                let waves: [RealmStatsWave] = response.map({ RealmStatsWave(result: $0) })
//                save(waves, startTime: startTime)
//            })
//            .store(in: &task)
//    }
    
    /// 総合記録読み込み
//    func total(startTime: Int) {
//        objects(FSCoopTotal.self, startTime: startTime)
//            .sink(receiveCompletion: { completion in
//            }, receiveValue: { [self] response in
//                let total: [RealmStatsTotal] = response.map({ RealmStatsTotal(result: $0) })
//                save(total, startTime: startTime)
//            })
//            .store(in: &task)
//    }
    
    /// オブジェクト読み込み
//    private func objects<T: Firecode>(_ type: T.Type, startTime: Int) -> AnyPublisher<[T], Error> {
//        #warning("ここでRealm呼んでるのちょっと微妙な気もする")
//        // 最後にアップデートした時間を取得
//        let lastPlayedTime: Int = {
//            guard let results = realm.objects(RealmCoopShift.self).first(where: { $0.startTime == startTime }),
//                  let lastPlayedTime = results.waves.max(by: { $0.playTime < $1.playTime })?.playTime
//            else {
//                return 0
//            }
//            return lastPlayedTime
//        }()
//        return Future { [self] promise in
//            firestore
//                .collection("schedules")
//                .document("\(startTime)")
//                .collection(type.path)
//                .whereField("playTime", isGreaterThanOrEqualTo: lastPlayedTime)
//                .getDocuments(completion: { (snapshot, _) in
//                    guard let snapshot = snapshot
//                    else {
//                        DDLogError("Firebase: No results")
//                        return
//                    }
//                    let data = snapshot.documents.compactMap({ try? self.decoder.decode(T.self, from: $0.data()) })
//                    promise(.success(data))
//                })
//        }
//        .eraseToAnyPublisher()
//    }
}
