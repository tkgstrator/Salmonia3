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
    
    func twitterSignOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            DDLogError(error)
        }
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
        uploaded.toggle()
    }
    
    internal func register(results: [CoopResult.Response]) {
        let waves: [FSCoopWave] = results.flatMap({ result -> [FSCoopWave] in
            result.waveDetails.map({ wave -> FSCoopWave in
                let index: Int = result.waveDetails.firstIndex(where: { $0 == wave }) ?? 0
                let members: [String] = result.members
                let startTime: Int = result.startTime
                let playTime: Int = result.playTime
                return FSCoopWave(result: wave, members: members, playTime: playTime, startTime: startTime, index: index)
            })
        })
        let totals: [FSCoopTotal] = results.map({ FSCoopTotal(result: $0) })
        let results: [FSCoopResult] = results.map({ FSCoopResult(result: $0) })
        create(results)
        create(waves)
        create(totals)
    }
    
    internal func registerTestData() {
        let data: FSCoopRecord = FSCoopRecord()
        create([data])
    }
    
    internal func incrementValue() {
        let data: FSCoopRecord = FSCoopRecord()
    }
    
    private func create<T: Firecode>(_ objects: [T], merge: Bool = false) {
        DispatchQueue(label: "Firebase").sync(execute: {
            let batch = firestore.batch()
            objects.compactMap({ batch.setData(try! $0.encoded(), forDocument: $0.reference, merge: true)})
            batch.commit(completion: { error in
                if let error = error {
                    DDLogError(error)
                    return
                }
                DDLogInfo("Success")
            })
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
