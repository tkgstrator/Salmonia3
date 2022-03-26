//
//  WaveView.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/27.
//

import SwiftUI
import RealmSwift
import SplatNet2

struct WaveView: View {
    let wave: RealmCoopWave
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            HStack(alignment: .top, spacing: nil, content: {
                HStack(alignment: .center, spacing: nil, content: {
                    Text(wave.waterLevel)
                    Text(wave.eventType)
                })
                .font(systemName: .Splatfont2, size: 14)
                Spacer()
                ResultEgg(goldenIkuraNum: wave.goldenIkuraNum, ikuraNum: wave.ikuraNum)
                    .frame(width: 160, height: 24, alignment: .bottom)
            })
            HStack(alignment: .lastTextBaseline, spacing: nil, content: {
                if let stageId = wave.stageId {
                    Image(stageId)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 44)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Spacer()
                if let weaponList = wave.weaponList {
                    ForEach(weaponList.indices, id: \.self) { index in
                        Image(weaponList[index])
                            .resizable()
                            .padding(4)
                            .scaledToFit()
                            .background(Circle().fill(.black.opacity(0.9)))
                            .frame(maxWidth: 40)
                    }
                }
            })
        })
    }
}

fileprivate extension RealmCoopWave {
    var weaponList: RealmSwift.List<WeaponType>? {
        return result.schedule?.weaponList
    }
    
    var stageId: StageId? {
        return result.stageId
    }
}

//struct WaveView_Previews: PreviewProvider {
//    static var previews: some View {
//        WaveView()
//    }
//}
