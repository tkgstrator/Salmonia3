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
import Combine

extension AppService {
    func getFriendActivityList() {
        session.getFriendActivityList()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    DDLogError(error)
                }
            }, receiveValue: { response in
                DDLogInfo(response)
            })
            .store(in: &task)
    }
    
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
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    DDLogInfo("Success")
                case .failure(let error):
                    DDLogError(error)
                }
            }, receiveValue: { response in
                DDLogInfo("Uploaded \(response.results.count)")
            })
            .store(in: &task)
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

