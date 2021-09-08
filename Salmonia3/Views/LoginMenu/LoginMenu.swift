//
//  LoginMenu.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/03/11.
//

import Foundation
import BetterSafariView
import SwiftUI
import SplatNet2
import Combine
import SDWebImageSwiftUI

struct LoginMenu: View {
    @State var isActive: Bool = false
    @State var oauthURL: URL?
    @State var isPresented: Bool = false
    @State var isAuthorized: Bool = false
    @State var task = Set<AnyCancellable>()
    @State var apiError: APIError?
    @State var isAnimating: Bool = true

    var body: some View {
        GeometryReader { geometry in
            Group {
                VStack {
                    Text(.TEXT_SALMONIA)
                        .splatfont2(size: 36)
                    
                    WebImage(forResource: "LoadingIka", isAnimating: $isAnimating)
                        .resizable()
                        .frame(width: 128, height: 128)
                    Text(.TEXT_WELCOME_SPLATNET2)
                        .splatfont2(.secondary, size: 18)
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                }
                .padding(.horizontal, 10)
                .position(x: geometry.frame(in: .local).midX, y: geometry.size.height / 4)
                Button(action: { isAuthorized.toggle()}, label: { Text(.BTN_SIGN_IN).splatfont2(size: 20) })
                    .authorize(isPresented: $isAuthorized) { completion in
                        switch completion {
                        case .success(let value):
                            isActive = value
                        case .failure(let error):
                            apiError = error
                        }
                    }
                .position(x: geometry.frame(in: .local).midX, y: 3 * geometry.size.height / 4)
            }
            .overlay(Helpbutton, alignment: .topTrailing)
            .alert(item: $apiError) { error in
                Alert(title: Text("Error"), message: Text(error.localizedDescription))
            }
            
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
        .navigationTitle(.TITLE_LOGIN)
    }

    var Helpbutton: some View {
        Button(action: { isPresented.toggle() },
               label: { Image(systemName: "questionmark.circle").resizable().frame(width: 35, height: 35).foregroundColor(.white).padding(.all, 20) })
    }
}


extension WebImage {
    init(forResource: String, isAnimating: Binding<Bool>) {
        let url = Bundle.main.url(forResource: forResource, withExtension: "png")
        self.init(url: url, isAnimating: isAnimating)
    }
}
