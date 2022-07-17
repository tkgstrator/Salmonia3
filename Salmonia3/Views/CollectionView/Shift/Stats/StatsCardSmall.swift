//
//  StatsCardSmall.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/26.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftyUI
import Surge
import SplatNet2

struct StatsCardSmall: View {
    @State private var scale: CGFloat = .zero
    let score: Double
    let other: Double
    let salmonId: BossId
    
    private var BossImage: Image {
        Image(salmonId)
    }

    var totalValue: Double {
        score + other
    }
    
    var textColor: Color {
        score > other ? .orange : .blue
    }
    
    init(stats: StatsModel.Defeated) {
        self.score = Double(stats.score)
        self.other = Double(stats.other)
        self.salmonId = stats.bossType
    }
    
    init(stats: StatsModel.Overview, salmonId: BossId) {
        self.score = Double(stats.score)
        self.other = Double(stats.other)
        self.salmonId = salmonId
    }
    
    init<T: BinaryFloatingPoint>(score: T, other: T) {
        self.score = Double(score)
        self.other = Double(other)
        self.salmonId = .flyfish
    }
    
    var Caption: some View {
        HStack(content: {
            Group(content: {
                RoundedRectangle(cornerRadius: 3).fill(Color.orange)
                    .frame(width: 10, height: 10, alignment: .center)
                Text("あなた")
                    .font(systemName: .Splatfont2, size: 14)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            })
            Group(content: {
                RoundedRectangle(cornerRadius: 3).fill(Color.blue)
                    .frame(width: 10, height: 10, alignment: .center)
                Text("みかた")
                    .font(systemName: .Splatfont2, size: 14)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            })
        })
            .padding(.horizontal, 4)
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.width / 120
            let width: CGFloat = geometry.width
            VStack(spacing: 4, content: {
                HStack(content: {
                    BossImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40 * scale, height: 40 * scale)
                    Spacer()
                })
                .font(systemName: .Splatfont2, size: 14 * scale)
                HStack(alignment: .center, spacing: 0, content: {
                    Rectangle().fill(.orange).frame(width: width * (1 - other / totalValue), height: 12 * scale)
                    Rectangle().fill(.blue).frame(width: width * (other / totalValue), height: 12 * scale)
                })
                ZStack(alignment: .bottomTrailing, content: {
                    Text(String(format: "%2.2f%%", score / totalValue * 100))
                        .font(systemName: .Splatfont2, size: 18 * scale)
                        .padding(.horizontal)
                })
                .frame(height: 18 * scale)
            })
        })
        .padding(.bottom)
        .padding(.horizontal, 8)
        .aspectRatio(16/11, contentMode: .fit)
        .background(RoundedRectangle(cornerRadius: 6).fill(Color.whitesmoke))
    }
}

struct StatsCardSmall_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), content: {
                ForEach(Range(0...2), id: \.self) { _ in
                    StatsCardSmall(score: 17, other: 11.9)
                }
            })
        })
            .padding()
            .preferredColorScheme(.dark)
    }
}
