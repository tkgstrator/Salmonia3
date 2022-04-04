//
//  ResultEgg.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/30.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI

struct ResultEgg: View {
    let goldenIkuraNum: Int
    let ikuraNum: Int
    
    var body: some View {
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.width / 160
            HStack(spacing: 3, content: {
                HStack(spacing: -10, content: {
                    Image(.golden)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18 * scale)
                    Spacer()
                    Text(String(format: "x%2d", goldenIkuraNum))
                        .foregroundColor(.white)
                })
                .padding(.horizontal, 6 * scale)
                .background(Capsule().fill(Color.blackrussian.opacity(0.85)))
                .frame(width: 78.5 * scale, height: 23.5 * scale)
                HStack(spacing: -10, content: {
                    Image(.power)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18 * scale)
                    Spacer()
                    Text(String(format: "x%4d", ikuraNum))
                        .foregroundColor(.white)
                })
                .padding(.horizontal, 6 * scale)
                .background(Capsule().fill(Color.blackrussian.opacity(0.85)))
                .frame(width: 78.5 * scale, height: 23.5 * scale)
            })
            .font(systemName: .Splatfont2, size: 13 * scale)
        })
        .aspectRatio(160/23.5, contentMode: .fit)
    }
}

struct ResultEgg_Previews: PreviewProvider {
    static var previews: some View {
        ResultEgg(goldenIkuraNum: 100, ikuraNum: 9999)
            .previewLayout(.fixed(width: 320, height: 48))
        ResultEgg(goldenIkuraNum: 100, ikuraNum: 9999)
            .previewLayout(.fixed(width: 160, height: 24))
    }
}
