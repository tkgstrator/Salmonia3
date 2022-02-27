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
    
    var StageImage: some View {
        let stageId: Schedule.StageId = {
            if let stageId = wave.stageId {
                return stageId
            }
            return Schedule.StageId.shakeup
        }()
        return Image(stageId)
            .resizable()
            .scaledToFit()
            .frame(height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.bottom)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            HStack(content: {
                Group(content: {
                    HStack(alignment: .center, spacing: nil, content: {
                        Text(wave.waterLevel)
                        Text(wave.eventType)
                    })
                })
                Spacer()
                ResultEgg(goldenIkuraNum: wave.goldenIkuraNum, ikuraNum: wave.ikuraNum)
            })
            LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 40, maximum: 50), spacing: nil, alignment: .top), count: 4), alignment: .trailing, spacing: nil, content: {
                if let weaponList = wave.weaponList {
                    ForEach(weaponList.indices) { index in
                        Image(weaponList[index])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(4)
                            .background(Circle().fill(.black.opacity(0.9)))
                    }
                }
            })
                .overlay(StageImage, alignment: .leading)
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
    
    var stageId: Schedule.StageId? {
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
