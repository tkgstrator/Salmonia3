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
import SwiftyJSON

struct LoginMenu: View {
    @State var isActive: Bool = false
    @State var isPresented: Bool = false
    @State var isShowing: Bool = false
    private let verifier: String = String.randomString
    
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
                Button(action: { isPresented.toggle() }, label: { Text("BTN_SIGN_IN").splatfont2(.black, size: 20) })
                    .buttonStyle()
                Button(action: {
                    #if DEBUG
                    // スキップして次に進む
                    isActive.toggle()
                    #else
                    // Nintendo Switch Onlineの登録画面に進む
                    isShowing.toggle()
                    #endif
                }, label: { Text("BTN_SIGN_UP").splatfont2(.black, size: 20) })
                    .buttonStyle()
            }
            .position(x: geometry.frame(in: .local).midX, y: 3 * geometry.size.height / 4)
        }
        .webAuthenticationSession(isPresented: $isPresented) {
            WebAuthenticationSession(url: verifier.oauthURL, callbackURLScheme: "npf71b963c1b7b6d119") { callbackURL, _ in
                #warning("ここでエラー処理をしないといけない")
                guard let code: String = callbackURL?.absoluteString.capture(pattern: "de=(.*)&", group: 1) else { return }
                try? loginSplatNet2(code: code, verifier: verifier)
            }
            .prefersEphemeralWebBrowserSession(false)
        }
        .safariView(isPresented: $isShowing) {
            SafariView(url: URL(string: "https://twitter.com/signup")!,
                       configuration: SafariView.Configuration(
                        entersReaderIfAvailable: false,
                        barCollapsingEnabled: true
                       )
            )
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
    
    func loginSplatNet2(code: String, verifier: String) throws -> (){
        DispatchQueue(label: "Login").async {
            do {
                let version: String = "1.10.1"
                var response: JSON = JSON()
                response = try SplatNet2.getSessionToken(code, verifier)
                guard let session_token: String = response["session_token"].string else { return }
                response = try SplatNet2.genIksmSession(session_token, version: version)
                guard let thumbnail_url = response["user"]["thumbnail_url"].string else { return }
                guard let nickname = response["user"]["nickname"].string else { return }
                guard let iksm_session = response["iksm_session"].string else { return }
                guard let nsaid = response["nsaid"].string else { return }
                let value: [String: Any?] = ["nsaid": nsaid, "nickname": nickname, "thumbnailURL": thumbnail_url, "iksmSession": iksm_session, "sessionToken": session_token, "isActive": true]
                try RealmManager.addNewAccount(account: RealmUserInfo(value: value))
                isActive.toggle()
            } catch (let error) {
                #warning("ここにエラー処理を書く")
                print(error)
            }
        }
    }
}
