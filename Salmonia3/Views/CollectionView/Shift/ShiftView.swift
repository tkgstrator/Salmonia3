//
//  ShiftView.swift
//  Salmonia3
//
//  Created by devonly on 2021/11/26.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet2
import Surge

struct ShiftView: View {
    let shift: RealmCoopShift
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter
    }()
    
    var StageImage: some View {
        Image(shift.stageId)
            .resizable()
            .scaledToFit()
            .frame(height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 0, content: {
            HStack(alignment: .center, spacing: nil, content: {
                Text(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(shift.startTime))))
                Text(verbatim: "-")
                Text(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(shift.endTime))))
            })
                .font(systemName: .Splatfont2, size: 14)
            HStack(alignment: .bottom, spacing: 0, content: {
                Image(shift.stageId)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
                HStack(content: {
                    ForEach(shift.weaponList.indices, id: \.self) { index in
                        Image(shift.weaponList[index])
                            .resizable()
                            .padding(4)
                            .scaledToFit()
                            .background(Circle().fill(.black.opacity(0.9)))
                            .frame(maxWidth: 45)
                    }
                })
            })
        })
    }
}

internal extension RealmCoopShift {
    /// スコア
//    var score: Double {
//        let scores: [Double] = weaponList.map({ weapon -> Double in
//            (weapon.rank * 4 + weapon.firePower * 1 + weapon.flexibility * 1 + weapon.handling * 3 + weapon.stability * 1 + weapon.mobility * 1) / 11
//        })
//        return Surge.sum(scores)
//    }
    
    /// 偏差値
//    var deviation: Double {
//        guard let shifts = realm?.objects(RealmCoopShift.self) else {
//            return 50
//        }
//        // 平均値
//        let avg: Double = Surge.sum(shifts.map({ $0.score })) / Double(shifts.count)
//        // 標準偏差
//        let std: Double = Surge.std(shifts.map({ $0.score }))
//        return (score - avg) / std * 10 + 50
//    }
}
