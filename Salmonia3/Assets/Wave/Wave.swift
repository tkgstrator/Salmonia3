//
//  Wave.swift
//  Salmonia3
//
//  Created by devonly on 2021/07/01.
//

import SwiftUI

private struct Wave: Shape {
    var offset: Angle
    var percent: Double
    static var isLoading: Bool = true
    
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(offset.degrees, percent) }
        set {
            offset = Angle(degrees: newValue.first)
            
            if percent == newValue.second {
                Wave.isLoading = false
            }
            if Wave.isLoading {
                percent = newValue.second
            }
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()

        let lowfudge = 0.02
        let highfudge = 0.98
        
        let newpercent = lowfudge + (highfudge - lowfudge) * percent
        let waveHeight = 0.03 * rect.height
        let yoffset = CGFloat(1 - newpercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offset
        let endAngle = offset + Angle(degrees: 360)
        
        p.move(to: CGPoint(x: 0, y: yoffset + waveHeight * CGFloat(sin(offset.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 10) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yoffset + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
        
        return p
    }
}

struct CircleWaveView: View {
    
    @State private var waveOffset = Angle(degrees: 0)
    @State private var percent: Int = 0
    @State private var isPresented: Bool = false
    let tide: Int

    var body: some View {
        GeometryReader { geo in
            Circle()
                .stroke(Color.blue, lineWidth: 0.025 * min(geo.size.width, geo.size.height))
                .shadow(radius: 3)
                .overlay(
                    Wave(offset: Angle(degrees: self.waveOffset.degrees), percent: Double(percent)/100)
                        .fill(Color(red: 0, green: 0.5, blue: 0.75, opacity: 0.5))
                        .clipShape(Circle().scale(0.92))
                )
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            if !isPresented {
                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                    self.waveOffset = Angle(degrees: 360)
                    self.percent = tide
                    self.isPresented = true
                }
            }
        }
    }
}
