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
                    DDLogInfo(result)
                })
            }
        })
    }
    
    internal func register() {
        let waves: [FSCoopWave] = realm.objects(RealmCoopWave.self).map({ FSCoopWave(result: $0) })
        for wave in waves.chunked(by: 500) {
            create(wave)
        }
        let totals: [FSCoopTotal] = realm.objects(RealmCoopResult.self).map({ FSCoopTotal(result: $0) })
        for total in totals.chunked(by: 500) {
            create(total)
        }
    }
    
    internal func register(results: [CoopResult.Response]) {
        let waves: [FSCoopWave] = results.flatMap({ result in result.waveDetails.map({ wave in FSCoopWave(result: wave, members: result.members, playTime: result.playTime, startTime: result.startTime) })})
        let totals: [FSCoopTotal] = results.map({ FSCoopTotal(result: $0) })
        create(waves)
        create(totals)
    }
    
    private func create<T: Firecode>(_ objects: [T], merge: Bool = false) {
        let batch = firestore.batch()
        objects.compactMap({ batch.setData(try! $0.encoded(), forDocument: $0.reference, merge: true)})
        batch.commit(completion: { error in
            if let error = error {
                DDLogError(error)
                return
            }
            DDLogInfo("Success")
        })
    }
    
    private func encode(_ object: FSCoopWave) throws -> [String: Any] {
        try encoder.encode(object)
    }
    
    /// データ読み込み
    func object(startTime: Int) {
        firestore
            .collection("schedules")
            .document("\(startTime)")
            .collection("waves")
            .getDocuments(completion: { (snapshot, _) in
                guard let snapshot = snapshot
                else {
                    DDLogError("Firebase: No results")
                    return
                }
                let data = snapshot.documents.compactMap({ try? self.decoder.decode(FSCoopWave.self, from: $0.data()) })
                DDLogInfo(data)
            })
    }
}
