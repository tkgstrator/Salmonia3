//
//  TextInputView.swift
//  Salmonia3
//
//  Created by Devonly on 3/28/21.
//

import Foundation
import UIKit
import SwiftUI

struct TextInputView: UIViewRepresentable {
    private var textField = UITextField()

    func makeUIView(context: Context) -> UITextField {
        textField.becomeFirstResponder()
        textField.font = UIFont.monospacedSystemFont(ofSize: 17, weight: .thin)
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

struct InputTokenView: View {
    @Binding var isPresented: Bool
    @State var textString: String = ""
    @AppStorage("apiToken") var apiToken: String?

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("TEXT_SALMONIA")
                    .splatfont2(size: 36)
                Text("TEXT_INPUT_API_TOKEN")
                    .splatfont2(.secondary, size: 18)
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
            }
            .padding(.horizontal, 10)
            .position(x: geometry.frame(in: .local).midX, y: geometry.size.height / 4)
            VStack(spacing: 40) {
                TextField(apiToken ?? "TEXT_INPUT_SALMON_STATS_API_TOKEN", text: $textString)
                    .autocapitalization(.none)
                    .underlineTextField()
                    .multilineTextAlignment(.center)
                    .font(.system(size: 18, weight: .thin, design: .monospaced))
                    .frame(maxWidth: geometry.size.width * 0.8, alignment: .center)
                Button(action: {
                    validate(input: textString)
                    isPresented.toggle()
                }, label: { Text("BTN_SET_API_TOKEN")
                    .splatfont2(.cloud, size: 20)
                })
                Button(action: { isPresented.toggle() }, label: {
                    Text("BTN_CANCEL")
                        .splatfont2(.cloud, size: 20)
                })
            }
            .buttonStyle(BlueButtonStyle())
            .position(x: geometry.frame(in: .local).midX, y: 3 * geometry.size.height / 4)
        }
        .background(BackGround)
        .navigationBarHidden(true)
    }

    var BackGround: some View {
        LinearGradient(gradient: Gradient(colors: [.blue, .river]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
    }

    private func validate(input: String) {
        if let validate = input.capture(pattern: "[0-9a-z].*", group: 0) {
            // 64文字なら簡易バリデーション成功
            if validate.count == 64 {
                apiToken = validate
            }
        }
    }
}

extension View {
    func underlineTextField() -> some View {
        self
            .padding(.vertical, 10)
            .overlay(Rectangle().frame(height: 2).padding(.top, 35))
            .foregroundColor(.secondary)
            .padding(10)
    }
}
