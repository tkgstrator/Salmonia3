//
//  FSCoopRecord.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/09.
//

import Foundation
import Foundation
import SplatNet2
import CryptoKit
import FirebaseFirestore
import FirebaseFirestoreSwift

/// WAVE記録
struct FSCoopRecord: Firecode {
    let startTime: Int
    let records: [Record]
    
    struct Record: Codable {
        let eventType: EventKey
        let waterLevel: WaterKey
        let distribution: [Distribution]
    }
    
    struct Distribution: Codable {
        let goldenIkuraNum: Int
        let count: Int
        
        init(goldenIkuraNum: Int, count: Int) {
            self.goldenIkuraNum = goldenIkuraNum
            self.count = count
        }
    }
    
    init() {
        self.startTime = 0
        self.records = EventKey.allCases.map({ eventType -> [Record] in
            WaterKey.allCases.map({ waterLevel -> Record in
                let distribution: [Distribution] = Range(0...1).map({ Distribution(goldenIkuraNum: $0, count: $0) })
                return Record(eventType: eventType, waterLevel: waterLevel, distribution: distribution)
            })
        }).flatMap({ $0 })
    }
}

extension FSCoopRecord {
    var reference: DocumentReference {
        Firestore
            .firestore()
            .collection("schedules")
            .document("\(self.startTime)")
    }
    
    static var path: String {
        "records"
    }
    
    var id: String {
        String(self.startTime)
    }
}
