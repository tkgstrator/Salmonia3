//
//  DetailView.swift
//  Salmonia3
//
//  Created by devonly on 2021/05/19.
//

import SwiftUI
import LocalAuthentication

struct DetailView: View {
    @EnvironmentObject var appManager: AppManager
    @State var isToggle: [Bool] = Array(repeating: false, count: 2)
    @State var isWarning: Bool = false
    @State private var warning: Warning?
    
    var body: some View {
        List {
            Section(header: Text(.SETTING_GENERAL)) {
                Toggle(LocalizableStrings.Key.SETTING_LOG_SEND.rawValue.localized, isOn: $appManager.isDebugMode)
                Toggle(LocalizableStrings.Key.SETTING_ENABLE_IMPORT.rawValue.localized, isOn: $appManager.importEnabled)
                Picker(selection: $appManager.importNum, label: Text(.SETTING_IMPORT_NUM)) {
                    ForEach(ImportType.allCases, id:\.rawValue) {
                        Text("\($0.rawValue)")
                    }
                }
            }
            Section(header: Text(.SETTING_IMPORTANT)) {
                Toggle(LocalizableStrings.Key.SETTING_RE_SIGN_IN.rawValue.localized, isOn: $isToggle[0])
                    .onChange(of: isToggle[0]) { value in
                        if value {
                            warning = .signin
                        }
                    }
                Toggle(LocalizableStrings.Key.SETTING_ERASE_DATA.rawValue.localized, isOn: $isToggle[1])
                    .onChange(of: isToggle[1]) { value in
                        if value {
                            warning = .erase
                        }
                    }
            }
        }
        .alert(item: $warning) { error in
            Alert(title: Text(.TEXT_CONFIRM),
                  message: Text(error.localizedDescription),
                  primaryButton: .default(Text(.BTN_CONFIRM),
                                          action: { changeState() }),
                  secondaryButton: .destructive(Text(.BTN_CANCEL),
                                                action: { isToggle = Array(repeating: false, count: 2)})
            )
        }
        .font(.custom("Splatfont2", size: 16))
        .navigationTitle(.TITLE_SETTINGS)
    }
    
//    private func authorizeWithBiometrics() {
//        if !isAuthorized {
//            if LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
//                LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: LocalizableStrings.Key.AUTHORIZED_WITH_BIOMETRICS.rawValue.localized) { (success, error) in
//                    if success { isAuthorized.toggle() }
//                }
//            } else {
//                LAContext().evaluatePolicy(.deviceOwnerAuthentication, localizedReason: LocalizableStrings.Key.AUTHORIZED_WITH_PASSCODE.rawValue.localized) { (success, error) in
//                    if success { isAuthorized.toggle() }
//                }
//            }
//        }
//    }
    
    private func changeState() {
        guard let index = isToggle.firstIndex(of: true) else { return }
        switch index {
        case 0:
            appManager.isFirstLaunch.toggle()
        case 1:
            try? RealmManager.eraseAllRecord()
        default:
            break
        }
        isToggle = Array(repeating: false, count: 2)
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
}

extension Warning: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .erase:
            return LocalizableStrings.Key.TEXT_ERASE_DATA.rawValue.localized
        case .signin:
            return LocalizableStrings.Key.TEXT_RE_SIGN_IN.rawValue.localized
        }
    }
}
struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
