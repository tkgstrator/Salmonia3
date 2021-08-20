//
//  ButtonStyle.swift
//  Salmonia3
//
//  Created by tkgstrator on 3/25/21.
//

import SwiftUI

struct CircleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.cloud : Color.blue)
            .overlay(Circle().stroke(Color.blue, lineWidth: 1))
            .background(Circle().foregroundColor(configuration.isPressed ? Color.blue : Color.cloud))
    }
}

struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 200, height: 50)
            .foregroundColor(configuration.isPressed ? Color.cloud : Color.blue.opacity(0.000000001))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.cloud, lineWidth: 3))
            .background(RoundedRectangle(cornerRadius: 20).foregroundColor(configuration.isPressed ? .cloud : Color.blue.opacity(0.000000001)))
    }
}
