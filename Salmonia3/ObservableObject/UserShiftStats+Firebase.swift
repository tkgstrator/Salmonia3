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
            }, receiveValue: { [self] response in
                let waves: [RealmStatsWave] = response.map({ RealmStatsWave(result: $0) })
                save(waves, startTime: startTime)
            })
            .store(in: &task)
    }
    
    /// 総合記録読み込み
    func total(startTime: Int) {
        objects(FSCoopTotal.self, startTime: startTime)
            .sink(receiveCompletion: { completion in
            }, receiveValue: { [self] response in
                let total: [RealmStatsTotal] = response.map({ RealmStatsTotal(result: $0) })
                save(total, startTime: startTime)
            })
            .store(in: &task)
    }
    
    /// オブジェクト読み込み
    private func objects<T: Firecode>(_ type: T.Type, startTime: Int) -> AnyPublisher<[T], Error> {
        #warning("ここでRealm呼んでるのちょっと微妙な気もする")
        // 最後にアップデートした時間を取得
        let lastPlayedTime: Int = {
            guard let results = realm.objects(RealmCoopShift.self).first(where: { $0.startTime == startTime }),
                  let lastPlayedTime = results.waves.max(by: { $0.playTime < $1.playTime })?.playTime
            else {
                return 0
            }
            return lastPlayedTime
        }()
        return Future { [self] promise in
            firestore
                .collection("schedules")
                .document("\(startTime)")
                .collection(type.path)
                .whereField("playTime", isGreaterThanOrEqualTo: lastPlayedTime)
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
        if realm.isInWriteTransaction {
            realm.add(objects, update: .modified)
            for object in objects {
                if let schedule = realm.objects(RealmCoopShift.self).first(where: { $0.startTime == startTime }),
                   !schedule.total.contains(object) {
                    schedule.total.append(objectsIn: [object])
                }
            }
        } else {
            realm.beginWrite()
            realm.add(objects, update: .modified)
            for object in objects {
                if let schedule = realm.objects(RealmCoopShift.self).first(where: { $0.startTime == startTime }),
                   !schedule.total.contains(object) {
                    schedule.total.append(objectsIn: [object])
                }
            }
            try? realm.commitWrite()
        }
    }
    
    internal func save(_ objects: [RealmStatsWave], startTime: Int) {
        if realm.isInWriteTransaction {
            realm.add(objects, update: .modified)
            for object in objects {
                if let schedule = realm.objects(RealmCoopShift.self).first(where: { $0.startTime == startTime }),
                   !schedule.waves.contains(object) {
                    schedule.waves.append(objectsIn: [object])
                }
            }
        } else {
            realm.beginWrite()
            realm.add(objects, update: .modified)
            for object in objects {
                if let schedule = realm.objects(RealmCoopShift.self).first(where: { $0.startTime == startTime }),
                   !schedule.waves.contains(object) {
                    schedule.waves.append(objectsIn: [object])
                }
            }
            try? realm.commitWrite()
        }
    }
}
