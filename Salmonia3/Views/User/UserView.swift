//
//  UserView.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/30.
//

import SwiftUI
import RealmSwift
import SplatNet2

struct UserView: View {
    @EnvironmentObject var service: AppManager
    @StateObject var user: UserStatsModel = UserStatsModel(nsaid: "91d160aa84e88da6")
    
    var body: some View {
        ScrollView(content: {
            PieChartView(user.results.map({ $0.timeLimit + $0.wipeOut }), caption: "失敗WAVE")
            PieChartView([user.results.map({ $0.timeLimit }).reduce(0, +), user.results.map({ $0.wipeOut }).reduce(0, +)], caption: "失敗理由")
            PieChartView([user.success, user.failure], caption: "バイト結果")
        })
    }
}

extension Realm {
    func results(nsaid: String) -> RealmSwift.Results<RealmCoopResult> {
        objects(RealmCoopResult.self).filter("pid=%@", nsaid)
    }
    
    func players(nsaid: String) -> RealmSwift.Results<RealmCoopPlayer> {
        objects(RealmCoopPlayer.self).filter("pid=%@", nsaid)
    }
}

final class UserStatsModel: ObservableObject {
    /// バイト回数
    let jobNum: Int
    /// クリア回数
    let success: Int
    /// 失敗回数
    let failure: Int
    /// 各WAVEごとのクリア回数と失敗理由と回数
    let results: [JobResult]
    
    init(nsaid: String) {
        let realm = try! Realm()
        let results = realm.results(nsaid: nsaid)
        self.jobNum = results.count
        self.results = [1, 2, 3].map({ result in
            let results = results.filter("failureWave=%@", result)
            return JobResult(
                success: results.filter("isClear=%@", true).count,
                timeLimit: results.filter("failureReason=%@", FailureReason.timeLimit.rawValue).count,
                wipeOut: results.filter("failureReason=%@", FailureReason.wipeOut.rawValue).count
            )
        })
        self.success = results.filter("isClear=%@", true).count
        self.failure = results.filter("isClear=%@", false).count
    }
    
    class JobResult {
        let success: Int
        let timeLimit: Int
        let wipeOut: Int
        
        init(success: Int, timeLimit: Int, wipeOut: Int) {
            self.success = success
            self.timeLimit = timeLimit
            self.wipeOut = wipeOut
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
