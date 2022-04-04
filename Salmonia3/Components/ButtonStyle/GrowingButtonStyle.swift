//
//  GrowingButtonStyle.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/24.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI

struct GrowingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
