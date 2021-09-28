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
    @State var angle: Angle = Angle(degrees: 0)
    @State var isPresented: Bool = false

    var body: some View {
        ZStack(alignment: .bottom, content: {
            ScrollView(.vertical, showsIndicators: false, content: {
                Text(.TEXT_WELCOME_SALMONSTATS)
                    .font(.custom("Splatfont2", size: 18))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .offset(x: 0, y: 100)
                    .padding()
                    .foregroundColor(.whitesmoke)
            }).introspectScrollView(customize: { scrollView in
                scrollView.isScrollEnabled = false
            })
            signInButton
                .offset(x: 0, y: -200)
        })
        .frame(UIScreen.main.bounds.size)
        .background(Wave().edgesIgnoringSafeArea(.all))
        .navigationBarItems(trailing: TutorialView())
        .navigationTitle(.TITLE_SALMONIA)
        .preferredColorScheme(.dark)
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
    }

    var signInButton: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            RoundedRectangle(cornerRadius: 10).fill(Color.whitesmoke).frame(width: 240, height: 50)
                .overlay(Text(.BTN_SIGN_IN).foregroundColor(.safetyorange).font(.custom("Splatfont2", size: 20)))
        })
        .padding()
        .webAuthenticationSession(isPresented: $isPresented, content: {
            WebAuthenticationSession(url: URL(string: "https://salmon-stats-api.yuki.games/auth/twitter")!, callbackURLScheme: "salmon-stats") { callbackURL, _ in
                guard let accessToken = callbackURL?.absoluteString.capture(pattern: "api-token=(.*)", group: 1) else { return }
                manager.apiToken = accessToken
                appManager.isFirstLaunch.toggle()
            }
            .prefersEphemeralWebBrowserSession(false)
        })
    }
}
