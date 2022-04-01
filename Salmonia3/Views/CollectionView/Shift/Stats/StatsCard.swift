//
//  StatsCard.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/26.
//

import SwiftUI
import SwiftyUI
import Surge

struct StatsCard: View {
    @State private var scale: CGFloat = .zero
    let score: Double
    let other: Double
    let caption: String
    
    var totalValue: Double {
        score + other
    }
    
    var textColor: Color {
        score > other ? .orange : .blue
    }
    
    init(stats: StatsModel.Overview) {
        self.score = Double(stats.score)
        self.other = Double(stats.other)
        self.caption = stats.caption
    }
    
    init<T: BinaryFloatingPoint>(score: T, other: T, caption: String) {
        self.score = Double(score)
        self.other = Double(other)
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
                        .font(systemName: .Splatfont2, size: 20)
                        .minimumScaleFactor(0.5)
                        .padding(.horizontal)
                    HStack(spacing: 2, content: {
                        Image(systemName: score > other ? .ArrowtriangleUpFill : .ArrowtriangleDownFill)
                            .imageScale(.small)
                        Text(String(format: "%2.2f", abs(score - other)))
                            .font(systemName: .Splatfont2, size: 14)
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
            .overlay(Caption, alignment: .bottom)
            .onAppear(perform: {
                withAnimation(.linear(duration: 1.5)) {
                    self.scale = 1.0
                }
            })
            .background(RoundedRectangle(cornerRadius: 6).fill(Color.whitesmoke).overlay(Text(caption).font(systemName: .Splatfont2, size: 14).padding(8), alignment: .topLeading))
    }
}

struct StatsCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), content: {
                ForEach(Range(0...1)) { _ in
                    StatsCard(score: 17, other: 11.9, caption: "Nyamo")
                }
            })
        })
            .padding()
            .preferredColorScheme(.dark)
    }
}
