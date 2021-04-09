//
//  SalmonStats.swift
//  Salmonia3
//
//  Created by Devonly on 3/28/21.
//

import SwiftUI
import BetterSafariView

struct SalmonStatsView: View {

    @Environment(\.presentationMode) var present
    @State var isPresented: Bool = false
    @State var isShowing: Bool = false
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

//    init() {
//        UINavigationBar.appearance().tintColor = isDarkMode ? UIColor.white : UIColor.black
//        UINavigationBar.appearance().titleTextAttributes = [
//            .font : UIFont.systemFont(ofSize: 20),
//            NSAttributedString.Key.foregroundColor : isDarkMode ? UIColor.white : UIColor.black
//        ]
//    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("TEXT_SALMON_STATS")
                    .splatfont2(size: 36)
                Text("TEXT_LOGIN_SALMON_STATS")
                    .splatfont2(.secondary, size: 18)
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
            }
            .padding(.horizontal, 10)
            .position(x: geometry.frame(in: .local).midX, y: geometry.size.height / 4)
            VStack(spacing: 40) {
                Button(action: { isPresented.toggle() }, label: {
                    Text("BTN_OPEN_SALMON_STATS")
                        .splatfont2(.cloud, size: 20)
                })
                Button(action: { isShowing.toggle() }, label: {
                    Text("BTN_INPUT_API_TOKEN")
                        .splatfont2(.cloud, size: 20)
                })
                Button(action: { present.wrappedValue.dismiss() }, label: {
                    Text("BTN_CANCEL")
                        .splatfont2(.cloud, size: 20)
                })
            }
            .buttonStyle(BlueButtonStyle())
            .position(x: geometry.frame(in: .local).midX, y: 3 * geometry.size.height / 4)
        }
        .background(BackGround)
        .safariView(isPresented: $isPresented) {
            SafariView(url: URL(string: "https://salmon-stats-api.yuki.games/auth/twitter")!,
                       configuration: SafariView.Configuration(
                        entersReaderIfAvailable: false,
                        barCollapsingEnabled: true
                       )
        )}
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $isShowing) {
            InputTokenView(isPresented: $isShowing)
        }
    }

    var BackGround: some View {
        Group {
            LinearGradient(gradient: Gradient(colors: [.blue, .river]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct SalmonStatsView_Previews: PreviewProvider {
    static var previews: some View {
        SalmonStatsView()
    }
}
