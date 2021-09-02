//
//  SalmonLoginMenu.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/03/11.
//

import Foundation
import SwiftUI
import CryptoKit
import BetterSafariView
import Alamofire
import SalmonStats

struct SalmonLoginMenu: View {
    @EnvironmentObject var appManager: AppManager
    @State var isActive: Bool = false
    @State var isPresented: Bool = false
    @State var isAlertShowing: Bool = true
    @State var oauthURL: URL?

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
                Button(action: { oauthURL = URL(string: "https://salmon-stats-api.yuki.games/auth/twitter") }, label: {
                    Text(.BTN_SIGN_IN)
                            .splatfont2(size: 20)
                })
            }
            .position(x: geometry.frame(in: .local).midX, y: 3 * geometry.size.height / 4)
        }
        .overlay(Helpbutton, alignment: .topTrailing)
        .safariView(isPresented: $isPresented) {
            SafariView(url: URL(string: "https://github.com/tkgstrator/Salmonia3/raw/develop/Resources/01.png")!,
                       configuration: SafariView.Configuration(
                        entersReaderIfAvailable: false,
                        barCollapsingEnabled: true
                       )
            )
            .preferredBarAccentColor(.clear)
            .preferredControlAccentColor(.accentColor)
            .dismissButtonStyle(.done)
        }
        .webAuthenticationSession(item: $oauthURL) { url in
            WebAuthenticationSession(url: url, callbackURLScheme: "salmon-stats") { callbackURL, _ in
                guard let accessToken = callbackURL?.absoluteString.capture(pattern: "api-token=(.*)", group: 1) else { return }
                manager.apiToken = accessToken
                appManager.isFirstLaunch.toggle()
            }
            .prefersEphemeralWebBrowserSession(false)
        }
        .alert(isPresented: $isAlertShowing) {
            Alert(title: Text(.ALERT_SIGN_IN), message: Text(.TEXT_SIGN_IN), dismissButton: .default(Text(.BTN_CONFIRM)))
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(.TITLE_LOGIN)
    }

    var Helpbutton: some View {
        Button(action: { isPresented.toggle() },
               label: { Image(systemName: "questionmark.circle").resizable().frame(width: 35, height: 35).foregroundColor(.white).padding(.all, 20) })
    }
}
