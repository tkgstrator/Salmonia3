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
            HStack(alignment: .top, content: {
                Group(content: {
                    HStack(alignment: .center, spacing: nil, content: {
                        Text(wave.waterLevel)
                        Text(wave.eventType)
                    })
                })
                Spacer()
                ResultEgg(goldenIkuraNum: wave.goldenIkuraNum, ikuraNum: wave.ikuraNum)
                    .frame(width: 160, height: 24, alignment: .center)
            })
            HStack(alignment: .bottom, spacing: 0, content: {
                if let stageId = wave.stageId {
                    Image(stageId)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Spacer()
                HStack(content: {
                    if let weaponList = wave.weaponList {
                        ForEach(weaponList.indices, id: \.self) { index in
                            Image(weaponList[index])
                                .resizable()
                                .padding(4)
                                .scaledToFit()
                                .background(Circle().fill(.black.opacity(0.9)))
                                .frame(maxWidth: 45)
                        }
                    }
                })
            })
        })
    }
}

fileprivate extension RealmCoopWave {
    var weaponList: RealmSwift.List<WeaponType>? {
        guard let realm = try? Realm() else {
            return nil
        }
        return realm.objects(RealmCoopShift.self).first(where: { $0.startTime == result.startTime })?.weaponList
    }
    
    var stageId: StageId? {
        guard let realm = try? Realm() else {
            return nil
        }
        return realm.objects(RealmCoopShift.self).first(where: { $0.startTime == result.startTime })?.stageId
    }
}

//struct WaveView_Previews: PreviewProvider {
//    static var previews: some View {
//        WaveView()
//    }
//}
