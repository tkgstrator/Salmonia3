//
//  SettingView.swift
//  Salmonia3
//
//  Created by tkgstrator on 3/14/21.
//

import SwiftUI
import SwiftyUI
import BetterSafariView
import SalmonStats
import SplatNet2

struct SettingView: View {
    typealias Sections = Setting.Sections
    @EnvironmentObject var appManager: AppManager
    @EnvironmentObject var results: CoreRealmCoop
    @State var selectedURL: URL? = nil
    @State var isActive: Bool = false
    @State var isPresented: Bool = false
    private let systemVersion: String = UIDevice.current.systemVersion
    private let systemName: String = UIDevice.current.systemName
    private let deviceName: String = UIDevice.current.localizedModel
    private let appVersion: String = "\(String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!))(\(String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")!)))"
    private let xProductVersion: String? = UserDefaults.standard.string(forKey: "xProductVersion")
    private let apiVersion: String? = UserDefaults.standard.string(forKey: "apiVersion")
    
    var body: some View {
        List {
            Sections.Account()
            Sections.Product()
            Sections.Appearance()
            
            /// SalmonStats更新機能
//            Section(header: Text(.HEADER_SALMONSTATS).splatfont2(.safetyorange, size: 14),
//                    footer: Text(.FOOTER_SALMONSTATS).splatfont2(.secondary, size: 13).environment(\.lineLimit, 2)) {
//                SettingMenu(title: .SETTING_UPLOAD, value: !(manager.apiToken?.isEmpty ?? true))
//                Button(action: { isPresented.toggle() }, label: { Text(.SETTING_IMPORT_RESULT) })
//                    .background(
//                        NavigationLink(destination: ImportingView(), isActive: $isActive, label: { EmptyView() })
//                            .disabled(true)
//                            .frame(width: 0, height: 0, alignment: .center)
//                            .opacity(0.0)
//                    )
//                    .alert(isPresented: $isPresented) {
//                        Alert(title: Text(.TEXT_CONFIRM),
//                              message: Text(.TEXT_IMPORT),
//                              primaryButton: .default(Text(.BTN_CONFIRM), action: { isActive.toggle() }),
//                              secondaryButton: .destructive(Text(.BTN_CANCEL)))
//                    }
//                NavigationLink(destination: UsernameView(), label: { Text(.SETTING_UPDATE_NAME)})
//            }

        }
        .font(.custom("Splatfont2", size: 16))
        .onWillDisappear {
            appManager.objectWillChange.send()
            results.objectWillChange.send()
        }
        .navigationTitle(.TITLE_SETTINGS)
    }
    
    var accountInfoSection: some View {
        Section(header: Text(.HEADER_USERINFO).splatfont2(.safetyorange, size: 14),
                footer: Text(.FOOTER_SPLATNET2).splatfont2(.secondary, size: 13).environment(\.lineLimit, 2)) {
            switch appManager.isPaid02 {
            case true:
                AccountPicker(manager: manager)
            case false:
                SettingMenu(title: .SETTING_ACCOUNT, value: manager.account.nickname)
            }
            SettingMenu(title: .SETTING_SPLATNET2, value: manager.playerId)
            SettingMenu(title: .RESULTS, value: manager.account.coop.jobNum)
        }
    }
   
    /// 課金機能へのNavigationLink
    var productLinkSection: some View {
        Section(header: Text(.HEADER_PRODUCT).splatfont2(.safetyorange, size: 14)) {
            NavigationLink(destination: FreeProductView(), label: { Text(.SETTING_FREE_PRODUCT) })
            NavigationLink(destination: PaidProductView(), label: { Text(.SETTING_PAID_PRODUCT) })
        }
    }
    
    var appearanceSection: some View {
        /// 見た目を変更
        Section(header: Text(.HEADER_APPEARANCE).splatfont2(.safetyorange, size: 14)) {
            Toggle(LocalizableStrings.Key.SETTING_DARKMODE.rawValue.localized, isOn: $appManager.isDarkMode)
            Button(action: {}, label: {
                Text(appManager.resultStyle.rawValue.localized)
            })
            .actionSheet(isPresented: $isPresented, content: {
                ActionSheet(title: Text("ResultStyle"), message: Text("Nyamo Nice"), buttons: [
                    .default(Text("")) { }
                ])
            })
            Button(action: {}, label: {
                Text(appManager.resultStyle.rawValue.localized)
            })
            .actionSheet(isPresented: $isPresented, content: {
                ActionSheet(title: Text("ResultStyle"), message: Text("Nyamo Nice"), buttons: [
                    .default(Text("")) { }
                ])
            })
        }
    }
    
    /// アプリケーションの基本情報
    var applicationInfoSection: some View {
        Section(header: Text(.HEADER_APPLICATION).splatfont2(.safetyorange, size: 14)) {
            privacyButton
            NavigationLink(destination: HelpView(), label: { Text(.TITLE_HELP) })
            NavigationLink(destination: DetailView(), label: { Text(.SETTING_DETAIL) })
            SettingMenu(title: .SETTING_API_VERSION, value: "\(xProductVersion.stringValue) (\(apiVersion.stringValue))")
            SettingMenu(title: .SETTING_APP_VERSION, value: "\(appVersion)")
        }
    }
    
    var privacyButton: some View {
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
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
