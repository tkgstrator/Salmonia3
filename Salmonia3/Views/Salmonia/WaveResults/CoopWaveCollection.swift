//
//  CoopWaveCollection.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/06/04.
//

import SwiftUI

struct CoopWaveCollection: View {
    @EnvironmentObject var main: CoreRealmCoop
    
    var body: some View {
        List {
            ForEach(main.waves.indices, id:\.self) { index in
                ZStack(alignment: .leading) {
                    NavigationLink(destination: CoopResultView(result: main.waves[index].result.first!)) {
                        EmptyView()
                    }
                    .opacity(0.0)
                    WaveOverview(wave: main.waves[index])
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(.TITLE_WAVE_COLLECTION)
    }
}

struct WaveOverview: View {
    @StateObject var wave: RealmCoopWave
    
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
            ForEach(wave.weaponLists.indices, id:\.self) { index in
                Image(weaponId: wave.weaponLists[index])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        
    }
    
    var StageInfo: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(StageType.init(rawValue: wave.result.first!.stageId)!.localizedName)
            HStack {
                Text(wave.waterLevel.tide.localized)
                Text(wave.eventType.localized)
            }
            .splatfont2(size: 16)
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
            })
            .padding(.horizontal, 8)
            .background(Capsule().fill(Color.black.opacity(0.85)))
            HStack(content: {
                Image(Egg.power)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                Text("x\(wave.ikuraNum)")
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
struct CoopWaveCollection_Previews: PreviewProvider {
    static var previews: some View {
        CoopWaveCollection()
    }
}
