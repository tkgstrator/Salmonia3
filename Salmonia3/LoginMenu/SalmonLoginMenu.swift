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
import SwiftyJSON

struct SalmonLoginMenu: View {
    @State var isActive: Bool = false
    @State var isPresented: Bool = false
    @State var oAuthURL: URL = URL(string: "https://salmon-stats-api.yuki.games/auth/twitter?redirect_to=salmon-stats://")!
    
    var body: some View {
        GeometryReader { geometry in
            Text("TEXT_WELCOME")
                .splatfont2(size: 26)
                .position(x: geometry.frame(in: .local).midX, y: geometry.size.height / 4)
            VStack(spacing: 40) {
                Button(action: { isPresented.toggle() }, label: { Text("BTN_SIGN_IN").splatfont2(.black) })
                    .buttonStyle()
                Button(action: { isActive.toggle() }, label: { Text("BTN_SIGN_UP").splatfont2(.black) })
                    .buttonStyle()
            }
            .position(x: geometry.frame(in: .local).midX, y: 3 * geometry.size.height / 4)
        }
        .webAuthenticationSession(isPresented: $isPresented) {
            WebAuthenticationSession(url: oAuthURL, callbackURLScheme: "salmon-stats") { callbackURL, _ in
                guard let oauthToken = callbackURL?.absoluteString.capture(pattern: "token=(.*)&", group: 1) else { return }
                guard let oauthVerifier = callbackURL?.absoluteString.capture(pattern: "verifier=(.*)", group: 1) else { return }
                #warning("とりあえずここでSalmon Statsのトークンを取得")
                print(oauthToken, oauthVerifier)
                #warning("ここでログイン画面に切り替わるはず")
                AppManager.isLogin(isLogin: true)
            }
            .prefersEphemeralWebBrowserSession(false)
        }
        .background(BackGround)
        .navigationTitle("TITLE_LOGIN")
        #warning("無効化しているOAuthURLを取得するための関数")
        //        .onAppear() {
        //            TwitterOAuth().getOAuthURL() { [self] response, _ in
        //                guard let oauthToken = response?["oauth_token"] else { return }
        //                guard let oauthTokenSecret = response?["oauth_token_secret"] else { return }
        //                oAuthURL = URL(string: "https://api.twitter.com/oauth/authenticate?oauth_token=\(oauthToken)")!
        //                print(oAuthURL)
        //            }
        //        }
    }
    
    var BackGround: some View {
        Group {
            LinearGradient(gradient: Gradient(colors: [.blue, .river]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        }
    }
}
