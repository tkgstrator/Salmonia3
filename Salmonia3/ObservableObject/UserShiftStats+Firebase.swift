//
//  UserShiftStats+Firebase.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/02.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CocoaLumberjackSwift
import Combine
import RealmSwift

extension UserShiftStats {
    /// WAVE記録読み込み
    func waves(startTime: Int) {
        objects(FSCoopWave.self, startTime: startTime)
            .sink(receiveCompletion: { completion in
            }, receiveValue: { response in
            })
            .store(in: &task)
    }
    
    /// 総合記録読み込み
    func total(startTime: Int) {
        objects(FSCoopTotal.self, startTime: startTime)
            .sink(receiveCompletion: { completion in
            }, receiveValue: { [self] response in
                let lastPlayedTime: Int = response.max(by: { $0.playTime < $1.playTime })?.playTime ?? startTime
                let total: [RealmStatsTotal] = response.map({ RealmStatsTotal(result: $0) })
                
                print(lastPlayedTime, total.count)
                // 最終取得時間を更新
                if let schedule = realm.objects(RealmCoopShift.self).first(where: { $0.startTime == startTime }) {
                    save(total, startTime: startTime)
                }
                
                let noNightEvent: [Int] = response.filter({ $0.eventType.allSatisfy({ $0 == .waterLevels })}).map({ $0.goldenEggs }).sorted(by: >)
                let nightEvent: [Int] = response.map({ $0.goldenEggs }).sorted(by: >)
                guard let rank: Int = nightEvent.firstIndex(of: Int(self.teamGoldenIkuraNum[1].score)) else {
                    return
                }
                self.teamGoldenIkuraNum[1].total = response.count
                self.teamGoldenIkuraNum[1].rank = rank + 1
                self.objectWillChange.send()
            })
            .store(in: &task)
    }
    
    /// オブジェクト読み込み
    private func objects<T: Firecode>(_ type: T.Type, startTime: Int) -> AnyPublisher<[T], Error> {
        #warning("ここでRealm呼んでるのちょっと微妙な気もする")
        // 最後にアップデートした時間を取得
        let lastPlayedTime: Int = {
            guard let results = realm.objects(RealmCoopShift.self).first(where: { $0.startTime == startTime }),
                  let lastPlayedTime = results.total.max(by: { $0.playTime < $1.playTime })?.playTime
            else {
                return 0
            }
            return lastPlayedTime
        }()
        print("Get \(lastPlayedTime)")
        return Future { [self] promise in
            firestore
                .collection("schedules")
                .document("\(startTime)")
                .collection(type.path)
                .whereField("playTime", isGreaterThan: lastPlayedTime)
                .getDocuments(completion: { (snapshot, _) in
                    guard let snapshot = snapshot
                    else {
                        DDLogError("Firebase: No results")
                        return
                    }
                    let data = snapshot.documents.compactMap({ try? self.decoder.decode(T.self, from: $0.data()) })
                    promise(.success(data))
                })
        }
        .eraseToAnyPublisher()
    }
    
    /// RealmObjects書き込み
    internal func save(_ objects: [RealmStatsTotal], startTime: Int) {
        guard let schedule = realm.objects(RealmCoopShift.self).first(where: { $0.startTime == startTime }) else {
            return
        }
        if realm.isInWriteTransaction {
            for object in objects {
                realm.create(RealmStatsTotal.self, value: object, update: .modified)
            }
            schedule.total.append(objectsIn: objects)
        } else {
            realm.beginWrite()
            for object in objects {
                realm.create(RealmStatsTotal.self, value: object, update: .modified)
            }
            try? realm.commitWrite()
        }
    }
}
