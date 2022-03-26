//
//  LoadingService.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/23.
//  
//

import Foundation
import SalmonStats
import Combine
import Alamofire
import SplatNet2
import Common
import FirebaseFirestoreSwift
import FirebaseFirestore
import RealmSwift
import CocoaLumberjackSwift

extension Notification.Name {
    static let didFinishedLoadResults = Notification.Name("didFinishedLoadResults")
    static let didFinishedLoadResultsWithError = Notification.Name("didFinishedLoadResultsWithError")
}

final class LoadingService: SalmonStatsSessionDelegate, ObservableObject {
    private let session: SalmonStats
    private let realm: Realm
    private let schemeVersion: UInt64 = 8192

    @Published var current: Int = 0
    @Published var maximum: Int = 0
    @Published var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init() {
        do {
            self.realm = try Realm()
        } catch {
            var config = Realm.Configuration.defaultConfiguration
            config.deleteRealmIfMigrationNeeded = true
            config.schemaVersion = schemeVersion
            self.realm = try! Realm(configuration: config, queue: nil)
        }
        self.session = SalmonStats()
        self.session.delegate = self
    }
    
    func downloadResultsFromSplatNet2() {
        let resultId: Int? = {
            if let nsaid: String = session.account?.credential.nsaid {
                return realm.objects(RealmCoopResult.self).filter("pid=%@", nsaid).max(ofProperty: "jobId") ?? 0
            }
            return nil
        }()
        
        if let resultId = resultId {
            self.session.uploadResults(resultId: resultId)
        } else {
            NotificationCenter.default.post(name: .didFinishedLoadResults, object: nil)
        }
    }
    
    private func uploadToFirestore<T: Firecode>(_ objects: [T], merge: Bool = false) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                let firestore: Firestore = Firestore.firestore()
                let batch = firestore.batch()
                for object in objects {
                    if let data = try? object.encoded() {
                        batch.setData(data, forDocument: object.reference, merge: merge)
                    }
                }
                batch.commit(completion: { error in
                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    promise(.success(()))
                })
            }
        }
        .eraseToAnyPublisher()
    }
    
    func uploadResultsToFirestore(results: [SalmonResult]) -> AnyPublisher<Void, Error> {
        let results: [FSCoopResult] = results.map({ FSCoopResult(result: $0) })
        return uploadToFirestore(results)
    }
    
    func uploadWaveResultsToNewSalmonStats(results: [SalmonResult]) -> AnyPublisher<Void, Error> {
        let results: [CoopResult.Response] = results.map({ $0.result })
        return session.uploadWaveResults(results: results)
            .map({ _ in })
            .mapError({ return $0 as Error })
            .eraseToAnyPublisher()
    }
    
    func save(results: [SalmonResult]) -> AnyPublisher<Void, Error> {
        let results: [RealmCoopResult] = results.map({ RealmCoopResult(from: $0.result, id: $0.id) })
        return save(results)
    }
    
    /// シフトに対してリザルト書き込みをする
    internal func save(_ results: [RealmCoopResult]) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { [self] promise in
                let schedules = realm.objects(RealmCoopShift.self)
                if realm.isInWriteTransaction {
                    realm.add(results, update: .modified)
                    for result in results {
                        if let schedule = schedules.first(where: { $0.startTime == result.startTime }),
                           !schedule.results.contains(result)
                        {
                            schedule.results.append(objectsIn: [result])
                        }
                    }
                } else {
                    realm.beginWrite()
                    realm.add(results, update: .modified)
                    for result in results {
                        if let schedule = schedules.first(where: { $0.startTime == result.startTime }),
                           !schedule.results.contains(result)
                        {
                            schedule.results.append(objectsIn: [result])
                        }
                    }
                    do {
                        try realm.commitWrite()
                        promise(.success(()))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func didFinishLoadResultsFromSplatNet2(results: [SalmonResult]) {
        save(results: results)
            .merge(with: uploadResultsToFirestore(results: results), uploadWaveResultsToNewSalmonStats(results: results))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    NotificationCenter.default.post(name: .didFinishedLoadResults, object: nil)
                case .failure(let error):
                    NotificationCenter.default.post(name: .didFinishedLoadResultsWithError, object: error)
                }
            }, receiveValue: { response in
            })
            .store(in: &cancellable)
    }

    func willReceiveSubscription(subscribe: Subscription) {
    }

    func willReceiveOutput(output: Decodable & Encodable) {
    }

    func willReceiveCompletion(completion: Subscribers.Completion<AFError>) {
    }

    func willReceiveCancel() {
    }

    func willReceiveRequest(request: Subscribers.Demand) {
    }

    func progressSignIn(state: SignInState) {
    }

    func isAvailableResults(current: Int, maximum: Int) {
        DispatchQueue.main.async(execute: {
            self.maximum = (maximum - current + 1)
        })
    }

    func isGettingResultId(current: Int) {
        DispatchQueue.main.async(execute: {
            self.current += 1
        })
    }

    func willRunningSplatNet2SignIn() {
    }

    func didFinishSplatNet2SignIn(account: UserInfo) {
    }

    func failedWithUnavailableVersion(version: String) {
    }

    func failedWithSP2Error(error: SP2Error) {
        DispatchQueue.main.async(execute: {
            NotificationCenter.default.post(name: .didFinishedLoadResultsWithError, object: error)
        })
    }
}
