//
//  StatsWave.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/04.
//

import SwiftUI
import SplatNet2

struct StatsWave: View {
    let values: [CGFloat] = [0.4, 0.3, 0.2, 0.1]
    let rankEgg: RankEgg
    
    var body: some View {
        RankedCirclebar(rankEgg: rankEgg)
    }
}

struct RankedCirclebar: View {
    /// 角度
    private var angles: [AnglePair] = [
        AnglePair(from: 0.0, to: 0.4, index: 0),
        AnglePair(from: 0.4, to: 0.7, index: 1),
        AnglePair(from: 0.7, to: 0.9, index: 2),
        AnglePair(from: 0.9, to: 1.0, index: 3)
    ]
    /// 自分の位置の角度
    private let degree: CGFloat
    /// アニメーション用の変数
    private let rank: Int?
    /// 値
    private let rankedValue: Int?
    /// 全体の人数
    private let total: Int?
    /// 色
    private let color: Color
    /// イベント
    private let eventType: EventKey
    /// 潮位
    private let waterLevel: WaterKey
    @State var isMoving: Bool = false
    
    init(rankEgg: RankEgg) {
        self.degree = {
            if let rank = rankEgg.rank, let total = rankEgg.total {
                return 180 * CGFloat(rank) / CGFloat(total)
            }
            return 180
        }()
        self.rank = rankEgg.rank
        self.rankedValue = rankEgg.goldenEggs
        self.total = rankEgg.total
        self.color = {
            if let rank = rankEgg.rank, let total = rankEgg.total {
                let ratio: Double = Double(rank) / Double(total)
                if ratio <= 0.1 {
                    return .gold
                }
                if ratio <= 0.3 {
                    return .silver
                }
                if ratio <= 0.6 {
                    return .bronze
                }
                return .blue
            }
            return .gray
        }()
        self.waterLevel = rankEgg.waterLevel
        self.eventType = rankEgg.eventType
    }
    
    var Background: some View {
        let description: Text = {
            if eventType != .cohockCharge {
                return Text(waterLevel) + Text(eventType)
            } else {
                return Text(eventType)
            }
        }()
        
        return RoundedRectangle(cornerRadius: 10)
            .fill(Color.whitesmoke)
            .overlay(
                description
                    .font(systemName: .Splatfont2, size: 13)
                    .padding(8),
                alignment: .topLeading)
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            let radius: CGFloat = min(geometry.frame(in: .local).midX, geometry.frame(in: .local).midY)
            ZStack(alignment: .center, content: {
                ForEach(angles.indices, id: \.self) { index in
                    let angle: AnglePair = angles[index]
                    Arc(angle: angle)
                        .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .foregroundColor(angle.color)
                }
                Circle().fill(Color.white)
                    .frame(width: 10, height: 10, alignment: .center)
                    .padding(4)
                    .background(Circle().fill(color))
                    .offset(x: -radius)
                    .rotationEffect(.degrees(isMoving ? 180 - degree : 0))
                    .animation(Animation.easeInOut(duration: 3), value: isMoving)
                Text(String(format: "%@", rankedValue.stringText))
                    .font(systemName: .Splatfont2, size: 26)
                    .offset(y: -10)
                Text(String(format: "%@人中%@位", total.stringText, rank.stringText))
                    .font(systemName: .Splatfont2, size: 14)
                    .offset(y: 20)
                    .foregroundColor(.secondary)
            })
                .offset(y: 30)
        })
            .scaledToFit()
            .padding()
            .padding(.bottom, 16)
            .background(Background)
            .onAppear(perform: {
                self.isMoving = true
            })
    }
}

fileprivate extension Optional where Wrapped == Int {
    var stringText: String {
        if let value = self {
            return String(format: "%d", value)
        }
        return "-"
    }
}

struct AnglePair {
    let from: Angle
    let to: Angle
    let color: Color
    
    init(from: CGFloat, to: CGFloat, index: Int) {
        self.from = Angle(degrees: 156 * from) + Angle(degrees: Double(index) * 8)
        self.to = Angle(degrees: 156 * to) + Angle(degrees: Double(index) * 8)
        self.color = {
            switch index {
            case 1:
                return .bronze
            case 2:
                return .silver
            case 3:
                return .gold
            default:
                return .blue
            }
        }()
    }
}

struct Arc: InsettableShape {
    var startAngle: Angle
    var endAngle: Angle
    var insetAmount = 0.0

    init(angle: AnglePair) {
        self.startAngle = angle.from
        self.endAngle = angle.to
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
    
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment: Angle = Angle.degrees(180)
        let modifiedStart: Angle = self.startAngle  - rotationAdjustment
        let modifiedEnd: Angle = self.endAngle - rotationAdjustment

        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: false)

        return path
    }
}

struct RankedPyramid: View {
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack(alignment: .top, content: {
                Pyramid()
            })
        })
    }
}

struct Pyramid: View {
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack(alignment: .center, content: {
                ForEach(Color.allCases.reversed(), id: \.self) { color in
                    let count: CGFloat = CGFloat(Color.allCases.count)
                    let index: CGFloat = CGFloat(Color.allCases.firstIndex(of: color) ?? 1) + 1
                    let width: CGFloat = min(geometry.frame(in: .local).maxX, geometry.frame(in: .local).maxY)
                    Triangle()
                        .foregroundColor(color.opacity(1))
                        .frame(width: width * index / count)
                    
                }
            })
        })
            .scaledToFit()
    }
}

//struct StatsWave_Previews: PreviewProvider {
//    static var previews: some View {
//        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), content: {
//            StatsWave()
//        })
//            .padding()
//    }
//}
