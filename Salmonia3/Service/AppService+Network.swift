//
//  AppService+Network.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/12.
//

import Foundation
import SalmonStats
import Common
import CocoaLumberjackSwift
import RealmSwift

extension AppService {
    var latestResultId: Int? {
        realm.objects(RealmCoopResult.self).latestResultId(account: account)
    }

    func loadResultsFromSplatNet2() {
        DDLogInfo("Getting result from \(latestResultId)")
        session.uploadResults(resultId: latestResultId)
    }
}

extension RealmSwift.Results where Element == RealmCoopResult {
    func latestResultId(account: UserInfo?) -> Int? {
        guard let nsaid = account?.credential.nsaid else {
            return nil
        }
        return self.filter("pid=%@", nsaid).max(ofProperty: "jobId")
    }
}

