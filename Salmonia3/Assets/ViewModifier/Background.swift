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

extension View {
    func backgroundColor(_ color: Color) -> some View {
        return self.modifier(BackGroundColor(color: color))
    }

}
