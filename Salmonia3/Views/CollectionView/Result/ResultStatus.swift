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
        HStack(spacing: nil, content: {
            HStack(spacing: 0, content: {
                Image(.rescue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 33.4)
                Spacer()
                Text("x\(helpCount)")
                    .foregroundColor(.white)
            })
                .frame(width: 66)
                .padding(.horizontal, 8)
                .background(Capsule().fill(Color.blackrussian.opacity(0.85)))
            HStack(spacing: 0, content: {
                Image(.help)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 33.4)
                Spacer()
                Text("x\(deadCount)")
                    .foregroundColor(.white)
            })
                .frame(width: 66)
                .padding(.horizontal, 8)
                .background(Capsule().fill(Color.blackrussian.opacity(0.85)))
        })
            .font(systemName: .Splatfont2, size: 14)
    }
}

struct ResultStatus_Previews: PreviewProvider {
    static var previews: some View {
        ResultStatus(deadCount: 3, helpCount: 3)
            .previewLayout(.fixed(width: 400, height: 120))
    }
}

struct Result_Previews: PreviewProvider {
    static var previews: some View {
        ResultPlayer(result: RealmCoopResult(dummy: true))
            .previewLayout(.fixed(width: 400, height: 120))
    }
}
