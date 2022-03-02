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

extension UserShiftStats {
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
    
    /// データ読み込み
    func total(startTime: Int) {
        firestore
            .collection("schedules")
            .document("\(startTime)")
            .collection("total")
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
