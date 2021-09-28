//
//  CoopShiftView.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/22.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI

struct CoopShiftView: View {
    @Environment(\.coopshift) var shift
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy MM/dd HH:mm"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            currentTime
            HStack(alignment: .center, spacing: nil, content: {
                VStack(alignment: .center, spacing: 4, content: {
                    Image(stageId: shift.stageId)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 112 * 5/6, height: 63 * 5/6)
                        .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    Text(StageType(rawValue: shift.stageId)!.localizedName)
                        .font(.custom("Splatfont2", size: 14))
//                        .minimumScaleFactor(1.0)
                        .frame(width: 112, height: 16)
                        .padding(.bottom, 8)
                })
                switch shift.weaponList.contains(-1) {
                case true:
                    randomShiftWeapon
                case false:
                    normalShiftWeapon
                }
            })
        })
        .foregroundColor(.primary)
    }
    
    var currentTime: some View {
        HStack(alignment: .center, spacing: nil, content: {
            Text(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(shift.startTime))))
            Text(verbatim: "-")
            Text(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(shift.endTime))))
        })
        .font(.custom("Splatfont2", size: 14))
    }
    
    var normalShiftWeapon: some View {
        VStack(alignment: .center, spacing: 0, content: {
            Text(.SUPPLIED_WEAPONS)
                .textCase(nil)
                .font(.custom("Splatfont2", size: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 50)), count: 4), alignment: .center, spacing: 0, pinnedViews: [], content: {
                ForEach(shift.weaponList.indices) { index in
                    Image(weaponId: shift.weaponList[index])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            })
        })
    }

    
    var randomShiftWeapon: some View {
        VStack(alignment: .center, spacing: 0, content: {
            Text(.SUPPLIED_WEAPONS)
                .textCase(nil)
                .font(.custom("Splatfont2", size: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5), alignment: .center, spacing: 0, pinnedViews: [], content: {
                ForEach(shift.weaponList.indices) { index in
                    Image(weaponId: shift.weaponList[index])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                Image(weaponId: shift.rareWeapon ?? 20000)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            })
        })
    }
}

struct CoopShiftView_Previews: PreviewProvider {
    static var previews: some View {
        CoopShiftView()
    }
}
