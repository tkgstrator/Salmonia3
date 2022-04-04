//
//  ResultStatus.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/30.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI

struct ResultStatus: View {
    let deadCount: Int
    let helpCount: Int
    
    var body: some View {
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.width / 160
            HStack(spacing: 3, content: {
                HStack(spacing: -10, content: {
                    Image(.rescue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 33.4 * scale)
                    Spacer()
                    Text(String(format: "x%2d", helpCount))
                        .foregroundColor(.white)
                })
                .padding(.horizontal, 6 * scale)
                .background(Capsule().fill(Color.blackrussian.opacity(0.85)))
                .frame(width: 78.5 * scale, height: 23.5 * scale)
                HStack(spacing: -10, content: {
                    Image(.help)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 33.4 * scale)
                    Spacer()
                    Text(String(format: "x%2d", deadCount))
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

struct ResultStatus_Previews: PreviewProvider {
    static var previews: some View {
        ResultStatus(deadCount: 3, helpCount: 3)
            .previewLayout(.fixed(width: 200, height: 30))
    }
}
