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
    private let verifier: String = String.randomString
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 40) {
                Text("TEXT_WELCOME")
                Spacer()
                Button(action: { isPresented.toggle() }, label: { Text("BTN_SIGN_IN") })
                    .buttonStyle()
                Button(action: { isActive.toggle() }, label: { Text("BTN_SIGN_UP") })
                    .buttonStyle()
            }
            .position(x: geometry.frame(in: .local).midX, y: geometry.size.height / 4)
        }
        .webAuthenticationSession(isPresented: $isPresented) {
            WebAuthenticationSession(url: verifier.oauthURL, callbackURLScheme: "npf71b963c1b7b6d119") { callbackURL, _ in
                #warning("ここでエラー処理をしないといけない")
                guard let code: String = callbackURL?.absoluteString.capture(pattern: "de=(.*)&", group: 1) else { return }
                try? loginSplatNet2(code: code, verifier: verifier)
            }
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
//                guard let realm = try? Realm() else { return }
                
                let value: [String: Any?] = ["nsaid": nsaid, "name": nickname, "image": thumbnail_url, "iksm_session": iksm_session, "session_token": session_token, "isActive": true]
                print(value)
                #warning("SplatNet2")
                // MainRealmの情報を更新する
//                realm.beginWrite()
//                switch realm.objects(UserInfoRealm.self).filter("nsaid=%@", nsaid).isEmpty {
//                case true:
//                    let user: UserInfoRealm = UserInfoRealm(value: value)
//                    let uuid: String = UIDevice.current.identifierForVendor!.uuidString
//                    guard let main: MainRealm = realm.objects(MainRealm.self).first else { return }
//                    main.active.append(user)
//                case false:
//                    realm.create(UserInfoRealm.self, value: value, update: .all)
//                }
//                try? realm.commitWrite()
//                // 終わったのでフラグを反転させる
//                isActive.toggle()
            } catch (let error) {
                print(error)
                // TODO: エラー発生時の処理を書く
//                appError = error as? CustomNSError
//                isPresented.toggle()
            }
        }
    }
}
