//
//  ResultStatus.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/30.
//

import SwiftUI

struct ResultStatus: View {
    let deadCount: Int
    let helpCount: Int
    
    var body: some View {
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.width / 200
            HStack(spacing: nil, content: {
                HStack(spacing: 0, content: {
                    Image(.rescue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 33.4 * scale)
                    Spacer()
                    Text("x\(helpCount)")
                        .foregroundColor(.white)
                })
                    .frame(width: 66 * scale)
                    .padding(.horizontal, 8 * scale)
                    .background(Capsule().fill(Color.blackrussian.opacity(0.85)))
                HStack(spacing: 0, content: {
                    Image(.help)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 33.4 * scale)
                    Spacer()
                    Text("x\(deadCount)")
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

struct ResultStatus_Previews: PreviewProvider {
    static var previews: some View {
        ResultStatus(deadCount: 3, helpCount: 3)
            .previewLayout(.fixed(width: 200, height: 30))
    }
}
