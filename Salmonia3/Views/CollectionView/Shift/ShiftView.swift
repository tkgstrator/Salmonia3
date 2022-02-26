//
//  ShiftView.swift
//  Salmonia3
//
//  Created by devonly on 2021/11/26.
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
            .frame(height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.bottom)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            Group(content: {
                HStack(alignment: .center, spacing: nil, content: {
                    Text(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(shift.startTime))))
                    Text(verbatim: "-")
                    Text(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(shift.endTime))))
                })
            })
            LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 40, maximum: 50), spacing: nil, alignment: .top), count: 4), alignment: .trailing, spacing: nil, content: {
                ForEach(shift.weaponList.indices) { index in
                    Image(shift.weaponList[index])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(4)
                        .background(Circle().fill(.black.opacity(0.9)))
                }
            })
                .overlay(StageImage, alignment: .leading)
//                Text(String(format: "偏差値 %2.2f", shift.deviation))
//                    .foregroundColor(.whitesmoke)
//                    .padding(.horizontal)
//                    .background(Capsule().fill(Color.red))
        })
    }
}

internal extension RealmCoopShift {
    /// スコア
    var score: Double {
        let scores: [Double] = weaponList.map({ weapon -> Double in
            (weapon.rank * 4 + weapon.firePower * 1 + weapon.flexibility * 1 + weapon.handling * 3 + weapon.stability * 1 + weapon.mobility * 1) / 11
        })
        return Surge.sum(scores)
    }
    
    /// 偏差値
    var deviation: Double {
        guard let shifts = realm?.objects(RealmCoopShift.self) else {
            return 50
        }
        // 平均値
        let avg: Double = Surge.sum(shifts.map({ $0.score })) / Double(shifts.count)
        // 標準偏差
        let std: Double = Surge.std(shifts.map({ $0.score }))
        return (score - avg) / std * 10 + 50
    }
}

extension WeaponType: Identifiable {
    public var id: Int { rawValue }
}
