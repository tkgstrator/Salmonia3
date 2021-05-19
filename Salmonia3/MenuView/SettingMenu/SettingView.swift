//
//  SettingView.swift
//  Salmonia3
//
//  Created by Devonly on 3/14/21.
//

import SwiftUI
import BetterSafariView
import SalmonStats

struct SettingView: View {

    @State var isWarning: Bool = false
    @State var isShowing: Bool = false
    @AppStorage("isFirstLaunch") var isFirstLaunch = true
    @AppStorage("isDarkMode") var isDarkMode = false
    private let systemVersion: String = UIDevice.current.systemVersion
    private let systemName: String = UIDevice.current.systemName
    private let deviceName: String = UIDevice.current.localizedModel
    private let appVersion: String = "\(String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!))(\(String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")!)))"

    var body: some View {
        #warning("ヘッダーのフォントを固定する方法ないのかな")
        Form {
            Section(header: Text("HEADER_USER_INFO").splatfont2(.orange, size: 14)) {
                SettingMenu(title: "UPLOAD", value: SalmonStats.shared.apiToken != nil)
                Toggle("RE_SIGN_IN", isOn: $isFirstLaunch)
            }
            Section(header: Text("HEADER_APPEARANCE").splatfont2(.orange, size: 14)) {
                Toggle("SETTING_USING_DARKMODE", isOn: $isDarkMode)
            }
            Section(header: Text("HEADER_PURCHASED").splatfont2(.orange, size: 14)) {
                NavigationLink(destination: FreeProductView(), label: { Text("SETTING_FREE_PRODUCT") })
                #if DEBUG
                NavigationLink(destination: PaidProductView(), label: { Text("SETTING_PAID_PRODUCT") })
                #endif
            }
            Section(header: Text("HEADER_SALMONSTATS").splatfont2(.orange, size: 14)) {
                NavigationLink(destination: ImportingView(), label: { Text("SETTING_IMPORT_RESULT")})
                NavigationLink(destination: UsernameView(), label: { Text("SETTING_UPDATE_NAME")})
            }
            Section(header: Text("HEADER_APPLICATION").splatfont2(.orange, size: 14)) {
                PrivacyButton
                Toggle("ERASE_SETTING", isOn: $isWarning)
                SettingMenu(title: "APP_VERSION", value: "\(appVersion)")
            }
            Section(header: Text("HEADER_DEVICE").splatfont2(.orange, size: 14)) {
                SettingMenu(title: "SYSTEM", value: "\(systemName) \(systemVersion)")
                SettingMenu(title: "DEVICE", value: "\(deviceName)")
            }
        }
        .alert(isPresented: $isWarning) {
            Alert(title: Text("ALERT_ERASE_SETTING"), message: Text("MESSAGE_WARNING"), primaryButton: .default(Text("BTN_CONFIRM"), action: { AppManager.erase() }), secondaryButton: .destructive(Text("BTN_CANCEL")))
        }
        .font(.custom("Splatfont2", size: 16))
        .navigationTitle("TITLE_SETTINGS")
    }

    var EraseButton: some View {
        HStack {
            Spacer()
            Text("")
            EmptyView()
        }
    }

    var PrivacyButton: some View {
        Button(action: { isShowing.toggle() }, label: { Text("SETTING_PRIVACY")})
            .safariView(isPresented: $isShowing) {
                SafariView(url: URL(string: "https://tkgstrator.work/?page_id=25126")!)
            }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

struct SettingMenu: View {
    let title: String
    let value: String

    init(title: String, value: Optional<Any>) {
        self.title = "SETTING_\(title)".localized
        self.value = value.stringValue
    }

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}
