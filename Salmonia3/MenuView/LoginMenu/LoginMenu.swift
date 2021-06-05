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
import SwiftyAPNGKit

struct LoginMenu: View {
    @State var isActive: Bool = false
    @State var oauthURL: URL?
    @State var isPresented: Bool = false
    @State var task = Set<AnyCancellable>()
    @State var apiError: SplatNet2.APIError?

    var body: some View {
        GeometryReader { geometry in
            Group {
                VStack {
                    Text(.TEXT_SALMONIA)
                        .splatfont2(size: 36)
                    Text(.TEXT_WELCOME_SPLATNET2)
                        .splatfont2(.secondary, size: 18)
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                }
                .padding(.horizontal, 10)
                .position(x: geometry.frame(in: .local).midX, y: geometry.size.height / 4)
                VStack(spacing: 40) {
                    Button(action: { oauthURL = SplatNet2.shared.oauthURL }, label: {
                        Text(.BTN_SIGN_IN)
                            .splatfont2(.cloud, size: 20)
                    })
                    if let _ = SplatNet2.shared.sessionToken {
                        Button(action: { migrateSplatNet2Account() }, label: {
                            Text(.BTN_MIGRATE)
                                .splatfont2(.cloud, size: 20)
                        })
                    }
                }
                .buttonStyle(BlueButtonStyle())
                .position(x: geometry.frame(in: .local).midX, y: 3 * geometry.size.height / 4)
            }
            .overlay(Helpbutton, alignment: .topTrailing)
        }
        .safariView(isPresented: $isPresented) {
            SafariView(url: URL(string: "https://github.com/tkgstrator/Salmonia3/raw/develop/Resources/00.png")!,
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
            WebAuthenticationSession(url: url, callbackURLScheme: "npf71b963c1b7b6d119") { callbackURL, _ in
                guard let code: String = callbackURL?.absoluteString.capture(pattern: "de=(.*)&", group: 1) else {
                    return
                }
                SplatNet2.shared.getCookie(sessionTokenCode: code)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            isActive.toggle()
                        case.failure(let error):
                            apiError = error
                        }
                    }, receiveValue: { response in
                        try? RealmManager.addNewAccount(from: response)
                    })
                    .store(in: &task)
            }
            .prefersEphemeralWebBrowserSession(false)
        }
        .alert(item: $apiError) { error in
            Alert(title: Text("ALERT_ERROR"),
                  message: Text(error.localizedDescription),
                  dismissButton: .default(Text("BTN_DISMISS")))
        }
        .background(BackGround)
        .navigationTitle(.TITLE_LOGIN)
    }

    func migrateSplatNet2Account() {
        if RealmManager.getActiveAccountsIsEmpty() {
            if let _ = SplatNet2.shared.sessionToken {
                SplatNet2.shared.getCookie()
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            print(error)
                        }
                    }, receiveValue: { response in
                        try? RealmManager.addNewAccount(from: response)
                        isActive.toggle()
                    })
                    .store(in: &task)
            }
        } else {
            isActive.toggle()
        }
    }
    
    var Helpbutton: some View {
        Button(action: { isPresented.toggle() },
               label: { Image(systemName: "questionmark.circle").resizable().frame(width: 35, height: 35).foregroundColor(.white).padding(.all, 20) })
    }
    
    var BackGround: some View {
        Group {
            LinearGradient(gradient: Gradient(colors: [.blue, .river]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            NavigationLink(destination: SalmonLoginMenu(), isActive: $isActive) { EmptyView() }
        }
    }
}
