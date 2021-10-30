//
//  Ranbow.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/24.
//

import Foundation
import SwiftUI

struct Rainbow: ViewModifier {
    let hueColors = stride(from: 0, to: 1, by: 0.01).map {
        Color(hue: $0, saturation: 1, brightness: 1)
    }

    func body(content: Content) -> some View {
        content
            .overlay(GeometryReader { (proxy: GeometryProxy) in
                ZStack {
                    LinearGradient(gradient: Gradient(colors: self.hueColors),
                                   startPoint: .leading,
                                   endPoint: .trailing)
                        .frame(width: proxy.size.width)
                }
            })
            .mask(content)
    }
}

struct RainbowAnimation: ViewModifier {
    @State var isOn: Bool = false
    let hueColors = stride(from: 0, to: 1, by: 0.01).map {
        Color(hue: $0, saturation: 1, brightness: 1)
    }
    var duration: Double = 4
    var animation: Animation {
        Animation
            .linear(duration: duration)
            .repeatForever(autoreverses: false)
    }
    
    func body(content: Content) -> some View {
        let gradient = LinearGradient(gradient: Gradient(colors: hueColors+hueColors), startPoint: .leading, endPoint: .trailing)
        return content.overlay(GeometryReader { proxy in
            ZStack {
                gradient
                    .frame(width: 2 * proxy.size.width)
                    .offset(x: isOn ? -proxy.size.width : 0)
            }
        })
        .onAppear {
            withAnimation(self.animation) {
                isOn = true
            }
        }
        .mask(content)
    }
}

extension Text {
    func rainbow() -> some View {
        self.modifier(Rainbow())
    }
    
    func rainbowAnimation() -> some View {
        if UserDefaults.standard.bool(forKey: "APP_APPEARANCE_COLORSTYLE") {
            return AnyView(self.modifier(RainbowAnimation()))
        } else {
            return AnyView(self)
        }
    }
}
