//
//  ResultOverview.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/24.
//

import SwiftUI
import SwiftyUI

struct ResultOverview: View {
    let result: RealmCoopResult
    let goldenEggs: Int
    let powerEggs: Int
    let dangerRate: Double
    
    init(_ result: RealmCoopResult) {
        self.result = result
        self.goldenEggs = result.goldenEggs
        self.powerEggs = result.powerEggs
        self.dangerRate = result.dangerRate
    }
    
    var body: some View {
        switch result.isClear {
            case true:
                ResultClear
                    .overlay(ResultEgg(goldenIkuraNum: result.goldenEggs, ikuraNum: result.powerEggs), alignment: .topTrailing)
            case false:
                ResultFailure
                    .overlay(ResultEgg(goldenIkuraNum: result.goldenEggs, ikuraNum: result.powerEggs), alignment: .topTrailing)
        }
    }
    
    var ResultClear: some View {
        HStack(alignment: .top, content: {
            LazyVStack(alignment: .leading, spacing: 0, content: {
                LazyHStack(spacing: nil, content: {
//                    Text("\(result.indexOfResults)")
//                        .font(.Splatfont2, size: 13)
                    Text("RESULT.CLEAR", comment: "バイトクリア")
                        .font(systemName: .Splatfont2, size: 13, foregroundColor: .green)
                })
                LazyHStack(content: {
                    Text(result.gradeId)
                    Text(result.gradePoint)
                    Text("↑").font(systemName: .Splatfont, size: 14, foregroundColor: .red)
                })
                    .font(systemName: .Splatfont, size: 14)
            })
        })
    }
    
    var ResultFailure: some View {
        HStack(alignment: .top, content: {
            LazyVStack(alignment: .leading, spacing: 0, content: {
                LazyHStack(spacing: nil, content: {
//                    Text("\(result.indexOfResults)")
//                        .font(.Splatfont2, size: 13)
                    Text("RESULT.DEFEATED", comment: "バイト失敗")
                        .font(systemName: .Splatfont2, size: 13, foregroundColor: .safetyorange)
                })
                LazyHStack(content: {
                    Text(result.gradeId)
                    Text(result.gradePoint)
                    Text(result.gradePointDelta == 0 ? "→" : "↓")
                })
                    .font(systemName: .Splatfont, size: 14)
            })
        })
    }
}

//struct ResultOverview_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultOverview(result)
//    }
//}
