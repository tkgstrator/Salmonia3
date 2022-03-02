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
            HStack(content: {
                Image(.golden)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                Spacer()
                Text("x\(goldenIkuraNum)")
                    .foregroundColor(.white)
            })
                .frame(width: 60)
                .padding(.horizontal, 8)
                .background(Capsule().fill(Color.blackrussian.opacity(0.85)))
            HStack(content: {
                Image(.power)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                Spacer()
                Text("x\(ikuraNum)")
                    .foregroundColor(.white)
            })
                .frame(width: 75)
                .padding(.horizontal, 8)
                .background(Capsule().fill(Color.blackrussian.opacity(0.85)))
        })
            .minimumScaleFactor(1.0)
            .font(systemName: .Splatfont2, size: 14)
    }
}

struct ResultEgg_Previews: PreviewProvider {
    static var previews: some View {
        ResultEgg(goldenIkuraNum: 100, ikuraNum: 1000)
    }
}
