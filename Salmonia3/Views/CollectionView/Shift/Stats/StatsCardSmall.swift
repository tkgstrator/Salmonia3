//
//  StatsCardSmall.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/26.
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
    
    private var bossType: Image {
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
            ZStack(content: {
                Group(content: {
                    Circle()
                        .trim(from: other / totalValue, to: 1.0 * scale)
                        .stroke(.orange, lineWidth: 6)
                        .opacity(0.8)
                        .rotationEffect(.degrees(-90))
                    Circle()
                        .trim(from: 0.0, to: other / totalValue * scale)
                        .stroke(.blue, lineWidth: 6)
                        .rotationEffect(.degrees(-90))
                    Text(String(format: "%2.2f", score))
                        .font(systemName: .Splatfont2, size: 16)
                        .minimumScaleFactor(0.5)
                        .padding(.horizontal)
                    HStack(spacing: 2, content: {
                        Image(systemName: score > other ? .ArrowtriangleUpFill : .ArrowtriangleDownFill)
                            .imageScale(.small)
                        Text(String(format: "%2.2f", abs(score - other)))
                            .font(systemName: .Splatfont2, size: 12)
                            .minimumScaleFactor(0.5)
                    })
                        .foregroundColor(textColor)
                        .offset(y: 20)
                })
                    .scaledToFit()
                    .padding()
            })
        })
            .scaledToFit()
            .padding(.top, 20)
            .padding(.bottom, 20)
            .onAppear(perform: {
                withAnimation(.linear(duration: 1.5)) {
                    self.scale = 1.0
                }
            })
            .overlay(Caption, alignment: .bottom)
            .background(RoundedRectangle(cornerRadius: 6).fill(Color.whitesmoke).overlay(bossType.resizable().frame(width: 30, height: 30, alignment: .center).padding(4), alignment: .topLeading))
    }
}

struct StatsCardSmall_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), content: {
                ForEach(Range(0...2)) { _ in
                    StatsCardSmall(score: 17, other: 11.9)
                }
            })
        })
            .padding()
            .preferredColorScheme(.dark)
    }
}
