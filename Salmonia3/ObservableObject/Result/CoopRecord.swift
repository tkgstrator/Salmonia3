//
//  CoopRecord.swift
//  Salmonia3
//
//  Created by devonly on 2021/05/09.
//

import Foundation
import RealmSwift

final class CoopRecord: Identifiable, ObservableObject {
    @Published var jobNum: Int?
    @Published var clearRatio: Double?
    @Published var maxGrade: Int?
    
    private var token: NotificationToken?
//    var goldenEggs: [[GoldenEggsRecord?]]
    
    init(stageId: Int) {
        token = RealmManager.shared.realm.objects(RealmCoopResult.self).observe{ [weak self] (changes: RealmCollectionChange) in
            let results = RealmManager.shared.realm.objects(RealmCoopResult.self).filter("stageId=%@", stageId)
            if results.isEmpty { return }
            
            self!.jobNum = results.count
            self!.clearRatio = calcRatio(results.filter("isClear=%@", true).count, divideBy: results.count)
            self!.maxGrade = results.max(ofProperty: "gradePoint")
        }
    }
    
    deinit {
        token?.invalidate()
    }
}

struct GoldenEggsRecord {
    var goldenEggs: Int
    var playTime: Int
    var tide: Int
    var event: Int
}
