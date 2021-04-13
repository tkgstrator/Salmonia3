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
    @State var appError: APPError? = nil
    @AppStorage("apiToken") var apiToken: String?

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
                        .splatfont2(size: 20)
                })
                Button(action: { getAPITokenFromClipboard() }, label: {
                    Text("BTN_PASTE_API_TOKEN")
                        .splatfont2(size: 20)
                })
            }
            .buttonStyle(BlueButtonStyle())
            .position(x: geometry.frame(in: .local).midX, y: 3 * geometry.size.height / 4)
        }
        .alert(isPresented: $isShowing) {
            Alert(title: Text("ALERT_ERROR"), message: Text(appError!.localizedDescription.localized))
        }
        .safariView(isPresented: $isPresented) {
            SafariView(url: URL(string: "https://salmon-stats-api.yuki.games/auth/twitter")!,
                       configuration: SafariView.Configuration(
                        entersReaderIfAvailable: false,
                        barCollapsingEnabled: true
                       )
        )}
    }
    
    func getAPITokenFromClipboard() {
        do {
            guard let clipboard = UIPasteboard.general.string else { throw APPError.empty }
            guard let apiToken = clipboard.capture(pattern: "[0-9a-z].*", group: 0) else { throw APPError.invalid }
            if apiToken.count == 64 {
                self.apiToken = apiToken
            } else {
                throw APPError.invalid
            }
        } catch(let error) {
            appError = error as? APPError
            isShowing.toggle()
        }
    }
}

struct SalmonStatsView_Previews: PreviewProvider {
    static var previews: some View {
        SalmonStatsView()
    }
}
