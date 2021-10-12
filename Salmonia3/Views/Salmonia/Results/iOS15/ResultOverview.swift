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
        ZStack(alignment: .topLeading) {
            Text("\(result.indexOfResults)")
                .splatfont2(size: 12)
                .offset(y: 0)
            HStack(spacing: 0) {
                ResultJob
                Spacer()
                ResultGrade
                Spacer()
                ResultEggs
            }
        }
        .frame(maxWidth: .infinity)
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
    
    var ResultJob: some View {
        if result.isClear {
            return AnyView(
                Text(.RESULT_CLEAR)
                    .splatfont(.green, size: 13)
                    .frame(width: 60)
            )
        } else {
            return AnyView(
                Text(.RESULT_DEFEAT)
                    .splatfont(.safetyorange, size: 13)
                    .frame(width: 60)
            )
        }
    }
    
    var ResultEggs: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(Egg.golden).resize()
                Text("x\(result.goldenEggs)")
                    .splatfont2(size: 15)
                    .frame(width: 45, height: 22, alignment: .leading)
            }
            HStack {
                Image(Egg.power).resize()
                Text("x\(result.powerEggs)")
                    .splatfont2(size: 15)
                    .frame(width: 50, height: 22, alignment: .leading)
            }
        }
        .frame(width: 50)
    }
}
