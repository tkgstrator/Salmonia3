//
//  ResultHeader.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/26.
//  
//

import SwiftUI
import SplatNet2
import SwiftyUI

struct ResultHeader: View {
    let result: RealmCoopResult
    let foregroundColor: Color = Color(hex: "E5F100")
    
    var body: some View {
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.width / 356
            let dangerRateText: String = {
                if result.dangerRate != 200 {
                    return String(format: "キケン度 %.1f%%", result.dangerRate)
                }
                return String(format: "キケン度MAX!!", result.dangerRate)
            }()
            ResultEgg(goldenIkuraNum: result.goldenEggs, ikuraNum: result.powerEggs)
                .frame(width: 160 * scale, height: 23.5 * scale, alignment: .center)
            Text(dangerRateText)
                .font(systemName: .Splatfont, size: 20, foregroundColor: foregroundColor)
                .shadow(color: .black, radius: 0, x: 1, y: 1)
                .position(geometry.center)
        })
        .padding(8)
        .background(Image(result.stageId).resizable().scaledToFill().frame(height: 120).clipped())
        .aspectRatio(356/120, contentMode: .fit)
    }
}

struct ResultHeader_Previews: PreviewProvider {
    static var previews: some View {
        ResultHeader(result: RealmCoopResult(dummy: true))
            .previewLayout(.fixed(width: 356, height: 120))
    }
}
