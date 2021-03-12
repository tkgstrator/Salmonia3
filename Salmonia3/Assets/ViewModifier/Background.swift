//
//  Background.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/11.
//

import Foundation
import SwiftUI

struct BackGroundColor: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .background(color)
    }
}

struct ButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 200, height: 60)
            .backgroundcolor(.cloud)
            .cornerRadius(10)
    }
}

extension View {
    func backgroundcolor(_ color: Color) -> some View {
        return self.modifier(BackGroundColor(color: color))
    }
    
    func buttonStyle() -> some View {
        return self.modifier(ButtonStyle())
    }
}
