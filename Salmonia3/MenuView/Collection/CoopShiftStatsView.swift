//
//  CoopShiftStatsView.swift
//  Salmonia3
//
//  Created by Devonly on 3/23/21.
//

import SwiftUI

struct CoopShiftStatsView: View {
    lazy var stats: RealmCoopStats = RealmCoopStats()

    init(startTime: Int) {
//        stats = RealmCoopStats(startTime: startTime)
    }

    var body: some View {
        List {
            Text("TEST TEST")
        }
//        .onAppear() {
//            dump(stats)
//        }
    }
}

// struct CoopShiftStatsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CoopShiftStatsView()
//    }
// }
