//
//  SettingView.swift
//  Salmonia3
//
//  Created by Devonly on 3/14/21.
//

import SwiftUI

struct SettingView: View {
    
    @State var isWarning: Bool = false
    private let systemVersion: String = UIDevice.current.systemVersion
    private let systemName: String = UIDevice.current.systemName
    private let deviceName: String = UIDevice.current.name
    private let appVersion: String = "\(String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!))(\(String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")!)))"
    
    var body: some View {
        #warning("ヘッダーのフォントを固定する方法ないのかな")
        Form {
            Section(header: Text("HEADER_USER_INFO").splatfont2(.orange, size: 14)) {
                SettingMenu(title: "API_TOKEN", value: "\(systemName) \(systemVersion)")
            }
            Section(header: Text("HEADER_APPLICATION").splatfont2(.orange, size: 14)) {
                Toggle("ERASE_SETTING", isOn: $isWarning)
                SettingMenu(title: "APP_VERSION", value: "\(appVersion)")
            }
            Section(header: Text("HEADER_DEVICE").splatfont2(.orange, size: 14)) {
                SettingMenu(title: "SYSTEM", value: "\(systemName) \(systemVersion)")
                SettingMenu(title: "DEVICE", value: "\(deviceName)")
            }
        }
        // #warning("現在はログイン情報が消えるだけ")
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
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

struct SettingMenu: View {
    let title: String
    let value: String
    
    init(title: String, value: Any?) {
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

extension Optional where Wrapped == Any {
    var stringValue: String {
        switch self {
        case is Int:
            return String(self as! Int)
        case is Double:
            return "-"
        case is Bool:
            return "-"
        case is String:
            return self as! String
        default:
            return "-"
        }
    }
}
