//
//  CoopWaveCollection.swift
//  Salmonia3
//
//  Created by devonly on 2021/06/04.
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
        .navigationTitle(.TITLE_WAVE_COLLECTION)
    }
}

struct WaveOverview: View {
    @StateObject var wave: RealmCoopWave
    
    var body: some View {
        HStack(spacing: 0) {
            StageInfo
            Spacer()
            WeaponList
            Spacer()
            ResultEggs
        }
        .frame(maxWidth: .infinity)
    }
    
    var WeaponList: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: wave.weaponLists.count), spacing: 0) {
            ForEach(wave.weaponLists.indices, id:\.self) { index in
                Image(String(wave.weaponLists[index]).imageURL)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 30)
            }
        }
        
    }
    
    var StageInfo: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(StageType.init(rawValue: wave.result.first!.stageId.value!)!.name.localized)
            HStack {
                Text(wave.waterLevel!.localized)
                Text(wave.eventType!.localized)
            }
            .splatfont2(size: 16)
        }
        .splatfont2(size: 14)
        .frame(width: 90, alignment: .leading)
    }
    
    var ResultEggs: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image("49c944e4edf1abee295b6db7525887bd").resize()
                Text("x\(wave.goldenIkuraNum)")
                    .frame(width: 50, height: 18, alignment: .leading)
            }
            HStack {
                Image("f812db3e6de0479510cd02684131e15a").resize()
                Text("x\(wave.ikuraNum)")
                    .frame(width: 50, height: 18, alignment: .leading)
            }
        }
        .frame(width: 55)
        .splatfont2(size: 14)
    }
}

struct CoopWaveCollection_Previews: PreviewProvider {
    static var previews: some View {
        CoopWaveCollection()
    }
}
