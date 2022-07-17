//
//  StatsSpecial.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/27.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftyUI
import SplatNet2
import Surge

struct StatsSpecial: View {
    @State var scale: Double = .zero
    let specialList: [SpecialId]
    let probs: [Double]
    let counts: [Int]
    let colors: [Color] = [.red, .blue, .green, .yellow]
    
    init(specialProbs: [StatsModel.SpecialProb]) {
        self.specialList = specialProbs.map({ $0.specialId })
        self.probs = specialProbs.map({ $0.prob })
        self.counts = specialProbs.map({ $0.count })
    }
    
    var body: some View {
        HStack(content: {
            VStack(spacing: 5, content: {
                ForEach(specialList.indices, id: \.self) { index in
                    let specialType: SpecialId = specialList[index]
                    let prob: Double = probs[index]
                    let count: Int = counts[index]
                    let color: Color = colors[index]
                    HStack(spacing: 15, content: {
                        Image(specialType)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30, alignment: .center)
                            .padding(4)
                            .background(Circle().fill(Color.black.opacity(0.9)))
                        HStack(content: {
                            Text(String(format:"%05.2f%%", prob * 100))
                            Spacer()
                            Text(String(format:"(%d)", count))
                        })
                        .frame(maxWidth: 100)
                        .font(systemName: .Splatfont2, size: 16, foregroundColor: color)
                    })
                }
            })
            Spacer()
            GeometryReader(content: { geometry in
                ForEach(probs.indices, id: \.self) { index in
                    let currentValue: Double = sum(probs.prefix(index))
                    let totalValue: Double = sum(probs.prefix(index + 1))
                    Circle()
                        .trim(from: currentValue, to: totalValue * scale)
                        .stroke(colors[index], lineWidth: 10)
                }
            })
                .aspectRatio(1.0, contentMode: .fit)
                .frame(maxHeight: 130)
                .rotationEffect(.degrees(-90))
        })
            .padding()
            .aspectRatio(16/9, contentMode: .fit)
            .background(RoundedRectangle(cornerRadius: 6).fill(Color.whitesmoke))
            .onAppear(perform: {
                withAnimation(.linear(duration: 1.5)) {
                    self.scale = 1.0
                }
            })
    }
}
