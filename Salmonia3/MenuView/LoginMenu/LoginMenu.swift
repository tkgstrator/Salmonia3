//
//  LoginMenu.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/11.
//

import Foundation
import BetterSafariView
import SwiftUI
import SplatNet2
import Combine

struct LoginMenu: View {
    @State var isActive: Bool = false
    @State var isPresented: Bool = false
    @State var isShowing: Bool = false
    @State var task = Set<AnyCancellable>()

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("TEXT_SALMONIA")
                    .splatfont2(size: 36)
                Text("TEXT_WELCOME_SPLATNET2")
                    .splatfont2(.secondary, size: 18)
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
            }
            .padding(.horizontal, 10)
            .position(x: geometry.frame(in: .local).midX, y: geometry.size.height / 4)
            VStack(spacing: 40) {
                Button(action: { isPresented.toggle() }, label: {
                    Text("BTN_SIGN_IN")
                        .splatfont2(.cloud, size: 20)
                })
                Button(action: {
                    #if DEBUG
                    // スキップして次に進む
                    isActive.toggle()
                    #else
                    // Nintendo Switch Onlineの登録画面に進む
                    isShowing.toggle()
                    #endif
                }, label: { Text("BTN_SIGN_UP")
                    .splatfont2(.cloud, size: 20)
                })
            }
            .buttonStyle(BlueButtonStyle())
            .position(x: geometry.frame(in: .local).midX, y: 3 * geometry.size.height / 4)
        }
        .webAuthenticationSession(isPresented: $isPresented) {
            WebAuthenticationSession(url: SplatNet2.shared.oauthURL, callbackURLScheme: "npf71b963c1b7b6d119") { callbackURL, _ in
                #warning("ここでエラー処理をしないといけない")
                guard let code: String = callbackURL?.absoluteString.capture(pattern: "de=(.*)&", group: 1) else { return }
                SplatNet2.shared.getCookie(sessionTokenCode: code)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            isActive.toggle()
                        case.failure(let error):
                            print(error)
                        }
                    }, receiveValue: { response in
                        print(response)
                        try? RealmManager.addNewAccount(from: response)
                    })
                    .store(in: &task)
            }
            .prefersEphemeralWebBrowserSession(false)
        }
        .safariView(isPresented: $isShowing) {
            SafariView(url: URL(string: "https://my.nintendo.com/login")!,
                       configuration: SafariView.Configuration(
                        entersReaderIfAvailable: false,
                        barCollapsingEnabled: true))
            .preferredBarAccentColor(.clear)
            .preferredControlAccentColor(.accentColor)
            .dismissButtonStyle(.done)
        }
        .background(BackGround)
        .navigationTitle("TITLE_LOGIN")
    }

    var BackGround: some View {
        Group {
            LinearGradient(gradient: Gradient(colors: [.blue, .river]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            NavigationLink(destination: SalmonLoginMenu(), isActive: $isActive) { EmptyView() }
        }
    }
}
