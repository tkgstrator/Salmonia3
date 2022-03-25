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
        HStack(spacing: nil, content: {
            HStack(spacing: 0, content: {
                Image(.golden)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18)
                Spacer()
                Text(String(format: "x%2d", goldenIkuraNum))
                    .foregroundColor(.white)
            })
                .frame(width: 66)
                .padding(.horizontal, 8)
                .background(Capsule().fill(Color.blackrussian.opacity(0.85)))
            HStack(spacing: 0, content: {
                Image(.power)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18)
                Spacer()
                Text(String(format: "x%4d", ikuraNum))
                    .foregroundColor(.white)
            })
                .frame(width: 66)
                .padding(.horizontal, 8)
                .background(Capsule().fill(Color.blackrussian.opacity(0.85)))
        })
            .minimumScaleFactor(1.0)
            .font(systemName: .Splatfont2, size: 13)
    }
}

struct ResultEgg_Previews: PreviewProvider {
    static var previews: some View {
        ResultEgg(goldenIkuraNum: 100, ikuraNum: 9999)
            .previewLayout(.fixed(width: 400, height: 120))
    }
}
