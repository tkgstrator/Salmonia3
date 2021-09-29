//
//  WaveOverview.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/29.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI

struct WaveOverview: View {
    @Environment(\.wave) var wave
    
    var body: some View {
        HStack(spacing: 0) {
            StageInfo
            VStack(alignment: .trailing, spacing: 4, content: {
                ResultEggs
                WeaponList
            })
        }
        .frame(maxWidth: .infinity)
    }
    
    var WeaponList: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), spacing: 0) {
            ForEach(wave.weaponList.indices, id:\.self) { index in
                Image(weaponId: wave.weaponList[index])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        
    }
    
    var StageInfo: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(wave.stage.localizedName)
            if let waterLevel = wave.waterLevel, let eventType = wave.eventType {
                HStack {
                    Text(waterLevel.localizedName)
                    Text(eventType.localizedName)
                }
                .splatfont2(size: 16)
            }
            if let recordType = wave.recordType, let recordTypeEgg = wave.recordTypeEgg {
                HStack {
                    Text(recordType.localizedName)
                }
                .splatfont2(size: 16)
            }
        }
        .splatfont2(size: 14)
        .frame(width: 110, alignment: .leading)
    }
    
    var ResultEggs: some View {
        HStack(content: {
            HStack(content: {
                Image(Egg.golden)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                Text("x\(wave.goldenIkuraNum)")
                    .foregroundColor(.whitesmoke)
            })
            .padding(.horizontal, 8)
            .background(Capsule().fill(Color.black.opacity(0.85)))
            HStack(content: {
                Image(Egg.power)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                Text("x\(wave.ikuraNum)")
                    .foregroundColor(.whitesmoke)
            })
            .padding(.horizontal, 8)
            .background(Capsule().fill(Color.black.opacity(0.85)))
        })
        .minimumScaleFactor(1.0)
        .font(.custom("Splatfont2", size: 14))
    }
}

fileprivate extension String {
    var tide: String {
        switch self {
        case "high":
            return "HT"
        case "low":
            return "LT"
        case "normal":
            return "NT"
        default:
            return self
        }
    }
}
struct WaveOverview_Previews: PreviewProvider {
    static var previews: some View {
        WaveOverview()
    }
}
