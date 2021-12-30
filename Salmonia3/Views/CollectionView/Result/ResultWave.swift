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
                VStack(alignment: .center, spacing: nil, content: {
                    Text("RESULT.WAVE.\(wave.index + 1)")
                        .foregroundColor(.black)
                    Text("\(wave.goldenIkuraNum)/\(wave.quotaNum)")
                        .foregroundColor(.white)
                    Text("\(wave.ikuraNum)")
                    Text("\(wave.waterLevel)")
                        .minimumScaleFactor(1.0)
                    Text("\(wave.eventType)")
                        .minimumScaleFactor(1.0)
                })
            }
        })
    }
}

//struct ResultWave_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultWave()
//    }
//}
