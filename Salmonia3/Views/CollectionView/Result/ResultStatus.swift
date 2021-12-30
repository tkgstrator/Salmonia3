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
            HStack(content: {
                Image(.help)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35)
                Spacer()
                Text("x\(deadCount)")
                    .foregroundColor(.whitesmoke)
            })
                .frame(width: 60)
                .padding(.horizontal, 8)
                .background(Capsule().fill(Color.blackrussian.opacity(0.85)))
            HStack(content: {
                Image(.rescue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35)
                Spacer()
                Text("x\(helpCount)")
                    .foregroundColor(.whitesmoke)
            })
                .frame(width: 75)
                .padding(.horizontal, 8)
                .background(Capsule().fill(Color.blackrussian.opacity(0.85)))
        })
            .minimumScaleFactor(1.0)
            .font(systemName: .Splatfont2, size: 14)
    }
}

struct ResultStatus_Previews: PreviewProvider {
    static var previews: some View {
        ResultStatus(deadCount: 3, helpCount: 3)
    }
}
