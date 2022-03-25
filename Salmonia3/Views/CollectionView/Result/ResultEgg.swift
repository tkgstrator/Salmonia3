//
//  ResultEgg.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/30.
//

import SwiftUI

struct ResultEgg: View {
    let goldenIkuraNum: Int
    let ikuraNum: Int
    
    var body: some View {
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.width / 200
            HStack(spacing: nil, content: {
                HStack(spacing: 0, content: {
                    Image(.golden)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18 * scale)
                    Spacer()
                    Text(String(format: "x%2d", goldenIkuraNum))
                        .foregroundColor(.white)
                })
                .frame(width: 66 * scale)
                .padding(.horizontal, 8 * scale)
                .background(Capsule().fill(Color.blackrussian.opacity(0.85)))
                HStack(spacing: 0, content: {
                    Image(.power)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18 * scale)
                    Spacer()
                    Text(String(format: "x%4d", ikuraNum))
                        .foregroundColor(.white)
                })
                .frame(width: 66 * scale)
                .padding(.horizontal, 8 * scale)
                .background(Capsule().fill(Color.blackrussian.opacity(0.85)))
            })
            .font(systemName: .Splatfont2, size: 13 * scale)
            .position(geometry.center)
        })
        .aspectRatio(160/24, contentMode: .fit)
    }
}

struct ResultEgg_Previews: PreviewProvider {
    static var previews: some View {
        ResultEgg(goldenIkuraNum: 100, ikuraNum: 9999)
            .previewLayout(.fixed(width: 207, height: 30))
        ResultEgg(goldenIkuraNum: 100, ikuraNum: 9999)
            .previewLayout(.fixed(width: 160, height: 30 * 160 / 207))
    }
}
