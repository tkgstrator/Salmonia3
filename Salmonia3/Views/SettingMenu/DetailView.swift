//
//  DetailView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/05/19.
//

import SwiftUI
import LocalAuthentication

struct DetailView: View {
    @EnvironmentObject var appManager: AppManager
    @State var isToggle: [Bool] = Array(repeating: false, count: 3)
    @State var isWarning: Bool = false
    @State private var warning: Warning?
    
    var body: some View {
        List {
            Section(header: Text(.SETTING_GENERAL).splatfont2(.safetyorange, size: 14)) {
                Toggle(LocalizableStrings.Key.SETTING_LOG_SEND.rawValue.localized, isOn: $appManager.isDebugMode)
                HStack {
                    Picker(selection: $appManager.importNum, label: Text(.SETTING_IMPORT_NUM)) {
                        ForEach(ImportType.allCases, id:\.rawValue) {
                            Text("\($0.rawValue)")
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    Spacer()
                    Text("\(appManager.importNum)")
                        .foregroundColor(.secondary)
                }
            }
            Section(header: Text(.SETTING_IMPORTANT).splatfont2(.safetyorange, size: 14)) {
                Toggle(LocalizableStrings.Key.SETTING_RE_SIGN_IN.rawValue.localized, isOn: .init(
                    get: { isToggle[0] },
                    set: {
                        let _ = $0
                        warning = .signin
                    }
                ))
                Toggle(LocalizableStrings.Key.SETTING_LOGOUT_ALL.rawValue.localized, isOn: .init(
                    get: { isToggle[1] },
                    set: {
                        let _ = $0
                        warning = .logout
                    }
                ))
                Toggle(LocalizableStrings.Key.SETTING_ERASE_DATA.rawValue.localized, isOn: .init(
                    get: { isToggle[2] },
                    set: {
                        let _ = $0
                        warning = .erase
                    }
                ))
            }
        }
        .splatfont2(size: 16)
        .alert(item: $warning) { warning in
            Alert(title: Text(.TEXT_CONFIRM),
                  message: Text(warning.localizedDescription),
                  primaryButton: .default(Text(.BTN_CONFIRM),
                                          action: { changeState(warning: warning) }),
                  secondaryButton: .destructive(Text(.BTN_CANCEL))
            )
        }
        .navigationTitle(.TITLE_SETTINGS)
    }

    private func changeState(warning: Warning) {
        switch warning {
        case .erase:
            try? RealmManager.shared.eraseAllRecord()
        case .signin:
            appManager.isFirstLaunch = true
        case .logout:
            manager.deleteAllAccounts()
            appManager.isFirstLaunch = true
        }
    }
}

private enum ImportType: Int, CaseIterable {
    case type50     = 50
    case type75     = 75
    case type100    = 100
    case type125    = 125
    case type150    = 150
    case type175    = 175
    case type200    = 200
}

private enum Warning: Int, Error, Identifiable {
    var id: Int { rawValue }
    case erase  = 0
    case signin = 1
    case logout = 2
}

extension Warning: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .erase:
            return LocalizableStrings.Key.TEXT_ERASE_DATA.rawValue.localized
        case .signin:
            return LocalizableStrings.Key.TEXT_RE_SIGN_IN.rawValue.localized
        case .logout:
            return LocalizableStrings.Key.TEXT_ALL_LOGOUT.rawValue.localized
        }
    }
}
struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
