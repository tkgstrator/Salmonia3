//
//  ResultView.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/24.
//

import SwiftUI
import SwiftyUI

struct ResultView: View {
    let result: RealmCoopResult
    
//    fileprivate var formatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.timeZone = TimeZone.current
//        formatter.dateFormat = "yyyy MM/dd HH:mm"
//        return formatter
//    }()
    
    init(_ result: RealmCoopResult) {
        self.result = result
    }
    
    init(_ wave: RealmCoopWave) {
        self.result = wave.result
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            ScrollView(.vertical, showsIndicators: false, content: {
                ResultHeader(result: result)
                ResultWaveView(result: result)
                ResultPlayers(result: result)
                    .padding(.bottom, 10)
                ResultPlayerKills(result: result)
            })
        })
            .navigationBarTitleDisplayMode(.inline)
    }
}

extension RealmCoopWave {
    var index: Int {
        guard let index = self.result.wave.firstIndex(where: { $0.quotaNum == self.quotaNum }) else {
            return 0
        }
        return index + 1
    }
}

//struct ResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultView()
//    }
//}
