//
//  StatsCard.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/26.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftyUI
import Surge
import SplatNet2

enum StatsType: CaseIterable {
    case goldenIkuraNum
    case ikuraNum
    case bossDefeated
    case help
    case rescue
}

struct StatsCard: View {
    @State private var scale: CGFloat = .zero
    let score: Double
    let other: Double
    let caption: String
    let captionImage: Image
    
    var totalValue: Double {
        score + other
    }
    
    var textColor: Color {
        score > other ? .orange : .blue
    }
    
    init(stats: StatsModel.Overview, _ type: StatsType = .goldenIkuraNum) {
        self.score = Double(stats.score)
        self.other = Double(stats.other)
        self.captionImage = {
            switch type {
            case .goldenIkuraNum:
                return Image(ResultType.golden)
            case .ikuraNum:
                return Image(ResultType.power)
            case .help:
                return Image(ResultType.help)
            case .rescue:
                return Image(ResultType.rescue)
            case .bossDefeated:
                return Image(BossId.goldie)
            }
        }()
        self.caption = stats.caption
    }
    
    init<T: BinaryFloatingPoint>(score: T, other: T, caption: String, _ type: StatsType = .goldenIkuraNum) {
        self.score = Double(score)
        self.other = Double(other)
        self.captionImage = {
            switch type {
            case .goldenIkuraNum:
                return Image(ResultType.golden)
            case .ikuraNum:
                return Image(ResultType.power)
            case .help:
                return Image(ResultType.help)
            case .rescue:
                return Image(ResultType.rescue)
            case .bossDefeated:
                return Image(BossId.goldie)
            }
        }()
        self.caption = caption
    }
    
    var Caption: some View {
        HStack(content: {
            Group(content: {
                RoundedRectangle(cornerRadius: 4).fill(Color.orange)
                    .frame(width: 14, height: 14, alignment: .center)
                Text("あなた")
                    .font(systemName: .Splatfont2, size: 14)
            })
            Group(content: {
                RoundedRectangle(cornerRadius: 4).fill(Color.blue)
                    .frame(width: 14, height: 14, alignment: .center)
                Text("みかた")
                    .font(systemName: .Splatfont2, size: 14)
            })
        })
    }

    var body: some View {
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.width / 160
            let width: CGFloat = geometry.width
            VStack(spacing: 4 * scale, content: {
                HStack(spacing: 3 * scale, content: {
                    Text(caption)
                    Spacer()
                    captionImage
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20 * scale)
                })
                .font(systemName: .Splatfont2, size: 16 * scale)
                HStack(alignment: .center, spacing: 0, content: {
                    Rectangle().fill(.orange).frame(width: width * (1 - other / totalValue), height: 12 * scale)
                    Rectangle().fill(.blue).frame(width: width * (other / totalValue), height: 12 * scale)
                })
                ZStack(alignment: .center, content: {
                    Text(String(format: "%2.2f", score))
                        .font(systemName: .Splatfont2, size: 18 * scale)
                        .padding(.horizontal)
                    HStack(spacing: 2, content: {
                        Spacer()
                        Text(score >= other ? "+" : "-")
                        Text(String(format: "%2.2f%%", score / other))
                    })
                    .foregroundColor(textColor)
                    .font(systemName: .Splatfont2, size: 13 * scale)
                })
                .frame(height: 18 * scale)
            })
        })
        .padding(.bottom, 8)
        .padding(.horizontal, 8)
        .aspectRatio(16/7, contentMode: .fit)
        .background(RoundedRectangle(cornerRadius: 6).fill(Color.whitesmoke))
    }
}

struct StatsCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), content: {
                ForEach(Range(0...1), id: \.self) { _ in
                    StatsCard(score: 17, other: 11.9, caption: "Nyamo")
                }
            })
        })
            .padding()
            .preferredColorScheme(.dark)
    }
}
