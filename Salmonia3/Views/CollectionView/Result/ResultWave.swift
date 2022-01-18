//
//  ResultWave.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/30.
//

import SwiftUI

struct ResultWave: View {
    let result: RealmCoopResult
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: result.wave.count), content: {
            ForEach(result.wave) { wave in
                VStack(alignment: .center, spacing: 0, content: {
                    Text("RESULT.WAVE.\(wave.index)", comment: "WAVE数")
                        .font(systemName: .Splatfont2, size: 14)
                        .foregroundColor(.black)
                        .lineLimit(1)
                    Text("\(wave.goldenIkuraNum)/\(wave.quotaNum)")
                        .font(systemName: .Splatfont2, size: 20)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                    Text("\(wave.ikuraNum)")
                        .font(systemName: .Splatfont2, size: 12)
                        .foregroundColor(.red)
                    Text(wave.waterLevel.rawValue)
                        .font(systemName: .Splatfont2, size: 12)
                        .minimumScaleFactor(1.0)
                    Text(wave.eventType.rawValue)
                        .font(systemName: .Splatfont2, size: 12)
                        .minimumScaleFactor(1.0)
                })
//                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4).fill(Color.yellow))
            }
        })
            .background(Color.white.opacity(0.3))
    }
}

//struct ResultWave_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultWave()
//    }
//}
