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

struct StatsCardHalf: View {
    @State private var scale: CGFloat = .zero
    let score: Double
    let caption: String
    private let format: String
    
    init<T: BinaryFloatingPoint>(score: T, caption: String) {
        self.score = Double(score)
        self.caption = caption
        self.format = "%.2f"
    }
    
    init<T: BinaryInteger>(score: T, caption: String) {
        self.score = Double(score)
        self.caption = caption
        self.format = "%d"
    }
    
    var Background: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(Color.whitesmoke)
            .overlay(Text(caption)
                        .font(systemName: .Splatfont2, size: 14)
                        .padding(8),
                     alignment: .topLeading
                     )
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack(content: {
                Text(String(format: format, score))
                    .font(systemName: .Splatfont2, size: 20)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal)
            })
                .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
        })
            .aspectRatio(16/9, contentMode: .fit)
            .background(Background)
    }
}

struct StatsCardHalf_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), content: {
                ForEach(Range(0...1), id: \.self) { _ in
                    StatsCardHalf(score: 17, caption: "Nyamo")
                }
            })
        })
            .padding()
            .preferredColorScheme(.dark)
    }
}
