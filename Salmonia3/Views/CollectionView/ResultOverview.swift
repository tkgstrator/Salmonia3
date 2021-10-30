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
                    .overlay(ResultEggs, alignment: .topTrailing)
            case false:
                ResultFailure
                    .overlay(ResultEggs, alignment: .topTrailing)
        }
    }
    
    var ResultClear: some View {
        HStack(alignment: .top, content: {
            LazyVStack(alignment: .leading, spacing: 0, content: {
                LazyHStack(spacing: nil, content: {
//                    Text("\(result.indexOfResults)")
//                        .font(.Splatfont2, size: 13)
                    Text("Clear")
                        .font(systemName: .Splatfont2, size: 13, foregroundColor: .green)
                })
                LazyHStack(content: {
                    Text(result.gradeId.localized)
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
                    Text("Defeated")
                        .font(systemName: .Splatfont2, size: 13, foregroundColor: .safetyorange)
                })
                LazyHStack(content: {
                    Text(result.gradeId.localized)
                    Text(result.gradePoint)
                    Text(result.gradePointDelta == 0 ? "→" : "↓")
                })
                    .font(systemName: .Splatfont, size: 14)
            })
        })
    }
    
    var ResultEggs: some View {
        HStack(spacing: nil, content: {
            HStack(content: {
                Image(.golden)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                Spacer()
                Text("x\(result.goldenEggs)")
                    .foregroundColor(.whitesmoke)
            })
                .frame(width: 60)
                .padding(.horizontal, 8)
                .background(Capsule().fill(Color.blackrussian.opacity(0.85)))
            HStack(content: {
                Image(.power)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                Spacer()
                Text("x\(result.powerEggs)")
                    .foregroundColor(.whitesmoke)
            })
                .frame(width: 75)
                .padding(.horizontal, 8)
                .background(Capsule().fill(Color.blackrussian.opacity(0.85)))
        })
            .minimumScaleFactor(1.0)
            .font(systemName: .Splatfont2, size: 14)
    }
    
    
}

//struct ResultOverview_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultOverview(result)
//    }
//}
