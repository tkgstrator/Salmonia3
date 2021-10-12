//
//  ResultOverview.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/12.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI

struct ResultOverview: View {
    @StateObject var result: RealmCoopResult
    
    var body: some View {
        switch result.isClear {
            case true:
                resultClear
            case false:
                EmptyView()
        }
    }
    
    var ResultGrade: some View {
        if result.isClear {
            return AnyView(
                HStack {
                    Text(GradeType(rawValue: result.gradeId.intValue)!.localizedName)
                    Text("\(result.gradePoint.intValue)")
                    Text("↑").splatfont(.red, size: 14)
                }
                .splatfont(size: 14)
            )
        } else {
            return AnyView(
                HStack {
                    Text(GradeType(rawValue: result.gradeId.intValue)!.localizedName)
                    Text("\(result.gradePoint.intValue)")
                    Text(result.gradePointDelta.intValue == 0 ? "→" : "↓")
                }
                .splatfont(.gray, size: 14)
            )
        }
    }
    
    var resultClear: some View {
        HStack(alignment: .top, content: {
            LazyVStack(alignment: .leading, spacing: nil, content: {
                LazyHStack(spacing: nil, content: {
                    Text("\(result.indexOfResults)")
                        .splatfont2(size: 13)
                    Text(.RESULT_CLEAR)
                        .splatfont(.green, size: 13)
                })
                LazyHStack(content: {
                    Text(GradeType(rawValue: result.gradeId.intValue)!.localizedName)
                    Text("\(result.gradePoint.intValue)")
                    Text("↑").splatfont(.red, size: 14)
                })
                    .splatfont(size: 14)
            })
            Spacer()
            LazyVStack(content: {
                resultEggs
            })
        })
    }
    
    var resultFailure: some View {
        Text(.RESULT_DEFEAT)
            .splatfont(.safetyorange, size: 13)
    }
    
    var resultEggs: some View {
        HStack(content: {
            HStack(content: {
                Image(Egg.golden)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                Text("x\(result.goldenEggs)")
                    .foregroundColor(.whitesmoke)
            })
            .padding(.horizontal, 8)
            .background(Capsule().fill(Color.black.opacity(0.85)))
            HStack(content: {
                Image(Egg.power)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                Text("x\(result.powerEggs)")
                    .foregroundColor(.whitesmoke)
            })
            .padding(.horizontal, 8)
            .background(Capsule().fill(Color.black.opacity(0.85)))
        })
        .minimumScaleFactor(1.0)
        .font(.custom("Splatfont2", size: 14))
    }
}
