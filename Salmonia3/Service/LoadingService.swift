//
//  LoadingService.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/23.
//  Copyright © 2022 Magi Corporation. All rights reserved.
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
import FirebaseAuth
import SwiftUI

extension Notification.Name {
    static let didFinishedLogin = Notification.Name("didFinishedLogin")
    static let didFinishedLoginWithError = Notification.Name("didFinishedLogin")
    static let didFinishedLoadResults = Notification.Name("didFinishedLoadResults")
    static let didFinishedLoadResultsWithError = Notification.Name("didFinishedLoadResultsWithError")
}

final class LoadingService: SalmonStatsSessionDelegate, ObservableObject {
    internal var session: SalmonStats!
    internal let firestore: Firestore = Firestore.firestore()
    internal let encoder: Firestore.Encoder = Firestore.Encoder()
    internal let decoder: Firestore.Decoder = Firestore.Decoder()
    internal let provider: OAuthProvider = OAuthProvider(providerID: "twitter.com")

    @Published var current: Int = 0
    @Published var maximum: Int = 0
    @Published var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    @Published var account: Common.UserInfo = Common.UserInfo() {
        willSet {
            objectWillChange.send()
        }
    }
    @Published var isSalmonStatsSignedIn: Bool = false
    @Published var isFirestoreSignIn: Bool = false
    @Published var user: FirebaseAuth.User?
    /// 自動でAPIをアップデートする
    @AppStorage("APP_REFRESHABLE_TOKEN") var refreshable: Bool = true
    /// 自動でAPIをアップデートする
    @AppStorage("APP_REQUIRED_API_TOKEN") var requiredAPIToken: Bool = false
    /// シフト表示モード
    @AppStorage("APP_SHIFT_DISPLAY_MODE") var shiftDisplayMode: ShiftDisplayMode = .current

    init() {
        /// データ読込時に一瞬だけ立ち上がるので常に最新のデータが反映されている
        self.session = SalmonStats(refreshable: refreshable, requiredAPIToken: requiredAPIToken)
        self.account = self.session.account
        self.session.delegate = self
        self.isSalmonStatsSignedIn = true
//        self.isSalmonStatsSignedIn = session.apiToken != nil
        
        Auth.auth().addStateDidChangeListener({ (auth, user) in
            self.user = user
            self.isFirestoreSignIn = true
        })
    }
    
    /// SplatNet2からリザルトダウンロード
    func downloadResultsFromSplatNet2() {
        let resultId: Int? = {
            if !session.accounts.isEmpty {
                let nsaid: String = session.account.credential.nsaid
                return realm.objects(RealmCoopResult.self).filter("pid=%@", nsaid).max(ofProperty: "jobId") ?? 0
            }
            return nil
        }()
        
        if let resultId = resultId {
            self.session.downloadResults(resultId: resultId)
//            self.session.uploadResults(resultId: resultId)
        } else {
            NotificationCenter.default.post(name: .didFinishedLoadResults, object: nil)
        }
    }
    
    /// Firestoreにデータ保存
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
    
    /// Firestoreにデータ保存
    func uploadResultsToFirestore(results: [SalmonResult]) -> AnyPublisher<Void, Error> {
        let results: [FSCoopResult] = results.map({ FSCoopResult(result: $0) })
        return uploadToFirestore(results)
    }
    
    /// WAVE記録をアップロード
    func uploadWaveResultsToNewSalmonStats(results: [SalmonResult]) -> AnyPublisher<Void, Error> {
        let results: [CoopResult.Response] = results.map({ $0.result })
        return session.uploadWaveResults(results: results)
            .map({ _ in })
            .mapError({ return $0 as Error })
            .eraseToAnyPublisher()
    }
    
    /// リザルトをRealmに書き込み
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
    
    internal func signInWithTwitterAccount() {
        provider.getCredentialWith(nil, completion: { credential, error in
            if let error = error {
                DDLogError(error)
                return
            }
            if let credential = credential {
                Auth.auth().signIn(with: credential, completion: { result, error in
                    if let error = error {
                        DDLogError(error)
                        return
                    }
                })
            }
        })
    }
    
    /// リザルト取得後に通知を送るだけ
    func didFinishLoadResultsFromSplatNet2(results: [SalmonResult]) {
        save(results: results)
            .merge(with: uploadResultsToFirestore(results: results))
//            .merge(with: uploadResultsToFirestore(results: results), uploadWaveResultsToNewSalmonStats(results: results))
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

    func didFinishSplatNet2SignIn(account: Common.UserInfo) {
        objectWillChange.send()
    }

    func failedWithUnavailableVersion(version: String) {
    }

    func failedWithSP2Error(error: SP2Error) {
        DispatchQueue.main.async(execute: {
            NotificationCenter.default.post(name: .didFinishedLoadResultsWithError, object: error)
        })
    }
}



extension Common.UserInfo: Equatable {
    
}
