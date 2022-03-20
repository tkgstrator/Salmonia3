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
import SplatNet2

extension AppService {
    var latestResultId: Int? {
        realm.objects(RealmCoopResult.self).latestResultId(account: account)
    }

    /// リザルトをイカリング2からダウンロードしてSalmon Statsにアップロードする
    func loadResultsFromSplatNet2() {
        session.uploadResults(resultId: latestResultId)
    }
    
    /// New!! Salmon Statsにリザルトをアップロード
    func uploadWaveResultsToNewSalmonStats(results: [CoopResult.Response]) {
        session.uploadWaveResults(results: results)
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

