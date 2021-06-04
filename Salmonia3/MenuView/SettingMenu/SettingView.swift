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
    @EnvironmentObject var appManager: AppManager
    @EnvironmentObject var results: CoreRealmCoop
    @State var selectedURL: URL? = nil
    @State var isActive: Bool = false
    @State var isPresented: Bool = false
    private let systemVersion: String = UIDevice.current.systemVersion
    private let systemName: String = UIDevice.current.systemName
    private let deviceName: String = UIDevice.current.localizedModel
    private let appVersion: String = "\(String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!))(\(String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")!)))"
    private let apiVersion: String = SplatNet2.shared.version
    
    var body: some View {
        List {
            Section(header: Text(.HEADER_USERINFO).splatfont2(.orange, size: 14),
                    footer: Text(.FOOTER_SPLATNET2).splatfont2(.secondary, size: 12).environment(\.lineLimit, 2)) {
                SettingMenu(title: .SETTING_SPLATNET2, value: SplatNet2.shared.playerId)
                SettingMenu(title: .RESULTS, value: results.resultCount)
            }
            
            Section(header: Text(.HEADER_SALMONSTATS).splatfont2(.orange, size: 14),
                    footer: Text(.FOOTER_SALMONSTATS).splatfont2(.secondary, size: 12).environment(\.lineLimit, 2)) {
                SettingMenu(title: .SETTING_UPLOAD, value: SalmonStats.shared.apiToken != nil)
                Button(action: { isPresented.toggle() }, label: { Text(.SETTING_IMPORT_RESULT) })
                    .background(
                        NavigationLink(destination: ImportingView(), isActive: $isActive, label: { EmptyView() })
                            .disabled(true)
                            .frame(width: 0, height: 0, alignment: .center)
                            .opacity(0.0)
                    )
                    .alert(isPresented: $isPresented) {
                        Alert(title: Text(.TEXT_CONFIRM),
                              message: Text(.TEXT_IMPORT),
                              primaryButton: .default(Text(.BTN_CONFIRM), action: { isActive.toggle() }),
                              secondaryButton: .destructive(Text(.BTN_CANCEL)))
                    }
                NavigationLink(destination: UsernameView(), label: { Text(.SETTING_UPDATE_NAME)})
            }

            Section(header: Text(.HEADER_APPEARANCE).splatfont2(.orange, size: 14)) {
                Toggle(LocalizableStrings.Key.SETTING_DARKMODE.rawValue.localized, isOn: $appManager.isDarkMode)
                Picker(selection: $appManager.listStyle, label: Text(.SETTING_LISTSTYLE)) {
                    ForEach(ListStyle.allCases, id:\.rawValue) {
                        Text($0.rawValue.localized)
                            .tag($0)
                    }
                    .navigationTitle(.TITLE_SETTINGS)
                }
            }
            
            Section(header: Text(.HEADER_PRODUCT).splatfont2(.orange, size: 14)) {
                NavigationLink(destination: FreeProductView(), label: { Text(.SETTING_FREE_PRODUCT) })
                #if DEBUG
                NavigationLink(destination: PaidProductView(), label: { Text(.SETTING_PAID_PRODUCT) })
                #endif
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
//            .buttonStyle(PlainButtonStyle())
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
