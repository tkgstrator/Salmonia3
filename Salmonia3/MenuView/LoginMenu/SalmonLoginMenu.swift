//
//  SalmonLoginMenu.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/11.
//

import Foundation
import SwiftUI
import CryptoKit
import BetterSafariView
import Alamofire
import SalmonStats

struct SalmonLoginMenu: View {
    @Environment(\.presentationMode) var present
    @State var isActive: Bool = false
    @State var isPresented: Bool = false
    @State var oAuthURL: URL = URL(string: "https://salmon-stats-api.yuki.games/auth/twitter")!
    @AppStorage("isFirstLaunch") var isFirstLaunch = true

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text(.TEXT_SALMONSTATS)
                    .splatfont2(size: 36)
                Text(.TEXT_WELCOME_SALMONSTATS)
                    .splatfont2(.secondary, size: 18)
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
                Text(.TEXT_TUTORIAL_SALMONSTATS)
                    .splatfont2(.secondary, size: 18)
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
            }
            .padding(.horizontal, 10)
            .position(x: geometry.frame(in: .local).midX, y: geometry.size.height / 4)
            VStack(spacing: 40) {
                Button(action: { isPresented.toggle() }, label: {
                    Text(.BTN_SIGN_IN)
                            .splatfont2(.cloud, size: 20)
                })
            }
            .buttonStyle(BlueButtonStyle())
            .position(x: geometry.frame(in: .local).midX, y: 3 * geometry.size.height / 4)
        }
        .webAuthenticationSession(isPresented: $isPresented) {
            WebAuthenticationSession(url: oAuthURL, callbackURLScheme: "salmon-stats") { callbackURL, _ in
                guard let apiToken = callbackURL?.absoluteString.capture(pattern: "api-token=(.*)", group: 1) else { return }
                SalmonStats.shared.configure(apiToken: apiToken)
                isFirstLaunch = false
            }
            .prefersEphemeralWebBrowserSession(false)
        }
        .background(BackGround)
        .navigationBarBackButtonHidden(true)
        .navigationTitle(.TITLE_LOGIN)
    }

    var BackGround: some View {
        Group {
            LinearGradient(gradient: Gradient(colors: [.blue, .river]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        }
    }
}
