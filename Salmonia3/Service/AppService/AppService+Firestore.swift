//
//  AppService+Firestore.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/02.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import CocoaLumberjackSwift
import FirebaseAuth
import SplatNet2
import SalmonStats

extension AppService {
    func twitterSignIn() {
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
    
    func twitterSignOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            DDLogError(error)
        }
    }
    
    /// Firestoreにリザルトをアップロードする
    func uploadResultsToFirestore(results: [SalmonResult]) {
        let results: [FSCoopResult] = results.map({ FSCoopResult(result: $0) })
        self.create(results)
    }
    
    /// Firestoreにデータアップロード
    private func create<T: Firecode>(_ objects: [T], merge: Bool = false) {
        let batch = firestore.batch()
        for object in objects {
            batch.setData(try! object.encoded(), forDocument: object.reference, merge: true)
        }
        batch.commit(completion: { error in
            if let error = error {
                DDLogError(error)
                return
            }
            DDLogInfo("Success")
        })
    }
    
    func getResultsFromFirestore() {
        getResults()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    DDLogError(error)
                }
            }, receiveValue: { results in
                self.save(results: results)
            })
            .store(in: &task)
    }
    
    /// [QueryDocumentSnapshot] -> [FSCoopResult]
    private func convert(_ documents: [QueryDocumentSnapshot]) -> AnyPublisher<[FSCoopResult], Error> {
        documents
            .publisher
            .tryMap({ document throws -> FSCoopResult in
                return try self.decoder.decode(FSCoopResult.self, from: document.convertedData())
            })
            .collect()
            .eraseToAnyPublisher()
    }
    
    /// Get [FSCoopResult]
    private func getResults() -> AnyPublisher<[FSCoopResult], Error> {
        snapshot()
            .flatMap(maxPublishers: .max(1), { $0.chunked(by: 200).publisher })
            .flatMap(maxPublishers: .max(1), { self.convert($0) })
            .eraseToAnyPublisher()
    }
    
    /// -> [QueryDocumenSnapshot]
    private func snapshot() -> AnyPublisher<[QueryDocumentSnapshot], Error> {
        guard let nsaid: String = account?.credential.nsaid else {
            return Fail(outputType: [QueryDocumentSnapshot].self, failure: SP2Error.noNewResults)
                .eraseToAnyPublisher()
        }
        return Future { [self] promise in
            firestore
                .collection("users")
                .document(nsaid)
                .collection("results")
                .whereField("start_time", isGreaterThanOrEqualTo: 1646481600)
                .getDocuments(completion: { (querySnapShot, error) in
                    if let error = error {
                        DDLogError(error)
                    } else {
                        guard let documents = querySnapShot?.documents else {
                            DDLogError("Firebase: No results")
                            promise(.failure(SP2Error.noNewResults))
                            return
                        }
                        DDLogInfo("Document size: \(documents.count)")
                        promise(.success(documents))
                    }
                })
        }
        .eraseToAnyPublisher()
    }
}

extension Dictionary where Key == String, Value == Any {
    fileprivate func keysToCamelCase() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        for key in self.keys {
            dict[key.convertToCamelCase()] = {
                if let value = self[key] as? Dictionary {
                    return value.keysToCamelCase()
                }
                
                if let value = self[key] as? [Dictionary] {
                    return value.map({ $0.keysToCamelCase() })
                }
                return self[key]
            }()
        }
        return dict
    }
}

extension DocumentSnapshot {
    func convertedData() -> [String: Any] {
        guard let data = self.data() else {
            return [:]
        }
        return data.keysToCamelCase()
    }
}

extension String {
    private func capitalize() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    fileprivate func convertToCamelCase() -> String {
        let camelString: String = split(separator: "_").map({ $0.capitalized }).joined()
        return camelString.prefix(1).lowercased() + camelString.dropFirst()
    }
}
