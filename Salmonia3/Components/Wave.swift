//
//  Wave.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/19.
//

import Foundation
import SwiftUI

struct BackgroundWave: View {
    @State var offset: Angle = Angle(degrees: 0)
    @State var isAnimating: Bool = false
    let height: CGFloat = UIScreen.main.bounds.height
    let width: CGFloat = UIScreen.main.bounds.width
    let color: Color = .safetyorange
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top, content: {
                Color.white.edgesIgnoringSafeArea(.all)
                Wave(startAngle: Angle(degrees: 0), offset: offset / 2)
                    .fill(color.opacity(0.2))
                    .frame(width: geometry.frame(in: .local).width, height: geometry.frame(in: .local).height * 4 / 5 + 10)
                Wave(startAngle: Angle(degrees: 0), offset: offset)
                    .fill(color.opacity(0.5))
                    .frame(width: geometry.frame(in: .local).width, height: geometry.frame(in: .local).height * 4 / 5)
                Wave(startAngle: Angle(degrees: 40), offset: -offset)
                    .fill(color.opacity(0.9))
                    .frame(width: geometry.frame(in: .local).width, height: geometry.frame(in: .local).height * 4 / 5)
            })
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            isAnimating.toggle()
            if isAnimating {
                withAnimation(Animation.linear(duration: 6).repeatForever(autoreverses: false)) {
                    offset = Angle(degrees: 720)
                }
            }
        }
        .onDisappear {
            isAnimating.toggle()
        }
    }
}

private struct Wave: Shape {
    let graphWidth: CGFloat = 0.8
    let waveHeight: CGFloat = 30
    /// 初期の位相ズレ
    let startAngle: Angle
    /// アニメーションのためのオフセット
    var offset: Angle = Angle(degrees: 0)
    
    var animatableData: Double {
        get { offset.degrees }
        set { offset = Angle(degrees: newValue )}
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY - waveHeight))
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY - waveHeight))
        
        for angle in stride(from: 0.0, to: 360.0, by: 0.5) {
            let theta: Double = Angle(degrees: startAngle.degrees + angle + offset.degrees).radians
            let x = CGFloat(angle / 360.0) * (rect.width)
            let y = rect.maxY + CGFloat(sin(theta)) * waveHeight / 2 - waveHeight / 2
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.closeSubpath()
        return path
    }
}
