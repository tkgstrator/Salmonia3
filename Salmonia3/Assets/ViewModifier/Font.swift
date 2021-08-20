//
//  Font.swift
//  Salmonia3
//
//  Created by tkgstrator on 3/13/21.
//

import Foundation
import SwiftUI

struct Splatfont2: ViewModifier {
    let color: Color
    let size: CGFloat

    func body(content: Content) -> some View {
            content
                .font(.custom("Splatfont2", size: size))
                .foregroundColor(color)
    }
}

struct Splatfont: ViewModifier {
    let color: Color
    let size: CGFloat

    func body(content: Content) -> some View {
            content
                .font(.custom("Splatfont", size: size))
                .foregroundColor(color)
    }
}

extension View {
    func splatfont2(_ color: Color = .primary, size: CGFloat = 16) -> some View {
        return AnyView(self.modifier(Splatfont2(color: color, size: size)))
    }

    func splatfont(_ color: Color = .primary, size: CGFloat = 16) -> some View {
        return AnyView(self.modifier(Splatfont(color: color, size: size)))
    }
}
