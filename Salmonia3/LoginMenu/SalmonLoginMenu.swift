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
            VStack(spacing: 30) {
                Text("TEXT_WELCOME")
                Spacer()
                Button(action: { isPresented.toggle() }, label: { Text("BTN_SIGN_IN") })
                    .buttonStyle()
                Button(action: { }, label: { Text("BTN_SIGN_UP") })
                    .buttonStyle()
            }
            .position(x: geometry.frame(in: .local).midX, y: geometry.size.height / 4)
        }
        .webAuthenticationSession(isPresented: $isPresented) {
            WebAuthenticationSession(url: oAuthURL, callbackURLScheme: "salmon-stats") { callbackURL, _ in
                #warning("ここでエラー処理をしないといけない")
                print(callbackURL)
            }
        }
        .onAppear() {
            TwitterOAuth().getOAuthURL() { [self] response, _ in
                guard let oauthToken = response?["oauth_token"] else { return }
                guard let oauthTokenSecret = response?["oauth_token_secret"] else { return }
                oAuthURL = URL(string: "https://api.twitter.com/oauth/authenticate?oauth_token=\(oauthToken)")!
                print(oAuthURL)
            }
        }
        .background(BackGround)
        .navigationTitle("TITLE_LOGIN")
    }
    
    var BackGround: some View {
        Group {
            LinearGradient(gradient: Gradient(colors: [.blue, .river]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
//            NavigationLink(destination: TopMenu(), isActive: $isActive) { EmptyView() }
        }
    }
}
