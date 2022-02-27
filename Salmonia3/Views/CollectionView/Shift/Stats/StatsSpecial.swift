//
//  StatsSpecial.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/27.
//

import SwiftUI
import SwiftyUI
import SplatNet2

struct StatsSpecial: View {
    var body: some View {
        HStack(content: {
            VStack(content: {
                ForEach(SpecialId.allCases) { specialType in
                    HStack(content: {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundColor(.orange)
                            .frame(width: 14, height: 14, alignment: .center)
                        Image(specialType)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30, alignment: .center)
                        Text("25.00%")
                            .font(systemName: .Splatfont2, size: 14)
                    })
                }
            })
            Spacer()
            GeometryReader(content: { geometry in
                let width: CGFloat = geometry.frame(in: .local).width
                ZStack(content: {
                    Circle()
                        .frame(width: width, alignment: .center)
                    Circle()
                        .fill(Color.white)
                        .frame(width: width - 50, alignment: .center)
                })
            })
                .scaledToFit()
                .padding()
        })
            .padding()
            .aspectRatio(16/9, contentMode: .fit)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.whitesmoke))
            .padding()
    }
}

struct StatsSpecial_Previews: PreviewProvider {
    static var previews: some View {
        StatsSpecial()
    }
}

extension SpecialId: Identifiable {
    public var id: String { rawValue }
}

//extension Text {
//    init(_ specialType: SpecialId) {
//        let text: String = {
//            switch specialType {
//            case .splatBombLauncher:
//                return "キューバンボムピッチャー"
//            case .stingRay:
//                return ""
//            case .inkjet:
//                <#code#>
//            case .splashdown:
//                <#code#>
//            }
//        }
//    }
//}

//extension Image {
//    init(_ specialType: SpecialId) {
//        self.init("Special/\(specialType.rawValue)", bundle: .main)
//    }
//}
