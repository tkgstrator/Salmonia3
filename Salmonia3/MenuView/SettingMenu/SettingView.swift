//
//  SettingView.swift
//  Salmonia3
//
//  Created by Devonly on 3/14/21.
//

import SwiftUI
import BetterSafariView
import SalmonStats
import SplatNet2

struct SettingView: View {
    
    @EnvironmentObject var appManager: CoreRealmCoop
    @AppStorage("isFirstLaunch") var isFirstLaunch = true
    @AppStorage("isDarkMode") var isDarkMode = false
    @State var selectedURL: URL? = nil
    private let systemVersion: String = UIDevice.current.systemVersion
    private let systemName: String = UIDevice.current.systemName
    private let deviceName: String = UIDevice.current.localizedModel
    private let appVersion: String = "\(String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!))(\(String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")!)))"
    private let apiVersion: String = SplatNet2.shared.version
    
    var body: some View {
        List {
            Section(header: Text(.HEADER_USERINFO).splatfont2(.orange, size: 14)) {
                SettingMenu(title: .RESULTS, value: appManager.results.count)
            }
            
            Section(header: Text(.HEADER_APPEARANCE).splatfont2(.orange, size: 14)) {
                Toggle(LocalizableStrings.Key.SETTING_DARKMODE.rawValue.localized, isOn: $isDarkMode)
            }
            
            Section(header: Text(.HEADER_PRODUCT).splatfont2(.orange, size: 14)) {
                NavigationLink(destination: FreeProductView(), label: { Text(.SETTING_FREE_PRODUCT) })
                #if DEBUG
                NavigationLink(destination: PaidProductView(), label: { Text(.SETTING_PAID_PRODUCT) })
                #endif
            }
            
            Section(header: Text(.HEADER_SALMONSTATS).splatfont2(.orange, size: 14)) {
                SettingMenu(title: .SETTING_UPLOAD, value: SalmonStats.shared.apiToken != nil)
                NavigationLink(destination: ImportingView(), label: { Text(.SETTING_IMPORT_RESULT)})
                NavigationLink(destination: UsernameView(), label: { Text(.SETTING_UPDATE_NAME)})
            }
            
            Section(header: Text(.HEADER_APPLICATION).splatfont2(.orange, size: 14)) {
                PrivacyButton
                NavigationLink(destination: DetailView(), label: { Text(.SETTING_DETAIL) })
                SettingMenu(title: .SETTING_API_VERSION, value: "\(apiVersion)")
                SettingMenu(title: .SETTING_APP_VERSION, value: "\(appVersion)")
            }
            
            #if DEBUG
            Section(header: Text(.HEADER_DEVICE).splatfont2(.orange, size: 14)) {
                SettingMenu(title: .SETTING_SYSTEM, value: "\(systemName) \(systemVersion)")
                SettingMenu(title: .SETTING_DEVICE, value: "\(deviceName)")
            }
            #endif
        }
        .font(.custom("Splatfont2", size: 16))
        .navigationTitle(.TITLE_SETTINGS)
    }
    
    var EraseButton: some View {
        HStack {
            Spacer()
            Text("")
            EmptyView()
        }
    }
    
    var PrivacyButton: some View {
        Button(action: { selectedURL = URL(string: "https://tkgstrator.work/posts/1970/01/01/privacyporicy.html") }, label: { Text(.SETTING_PRIVACY) })
            .safariView(item: $selectedURL) { selectedURL in
                SafariView(
                    url: selectedURL,
                    configuration: SafariView.Configuration(
                        entersReaderIfAvailable: false,
                        barCollapsingEnabled: true
                    )
                )
                .preferredBarAccentColor(.clear)
                .preferredControlAccentColor(.accentColor)
                .dismissButtonStyle(.done)
            }
            .buttonStyle(PlainButtonStyle())
    }
}

struct SettingMenu: View {
    let title: String
    let value: String
    
    init(title: LocalizableStrings.Key, value: Optional<Any>) {
        self.title = title.rawValue.localized
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

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
