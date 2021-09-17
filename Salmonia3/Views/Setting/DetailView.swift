//
//  DetailView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/05/19.
//

import SwiftUI
import LocalAuthentication

extension Setting.Sections {
    struct Detail: View {
        @EnvironmentObject var appManager: AppManager
        @State var actionItems: [ActionSheet] = [
        ]
        @State var alertItems: [Alert] = [
            Alert(title: Text(.SETTING_ERASE_DATA), message: Text(.TEXT_ERASE_DATA), primaryButton: .default(Text(.BTN_CONFIRM), action: {}), secondaryButton: .cancel()),
            Alert(title: Text(.SETTING_RE_SIGN_IN), message: Text(.TEXT_RE_SIGN_IN), primaryButton: .default(Text(.BTN_CONFIRM), action: {}), secondaryButton: .cancel())
        ]
        
        var body: some View {
            Form {
                Section(header: Text(.SETTING_DETAIL).splatfont2(.safetyorange, size: 14)) {
                    Toggle(LocalizableStrings.Key.SETTING_LOG_SEND.rawValue.localized, isOn: $appManager.isDebugMode)
                }
                .splatfont2(size: 16)
                .navigationTitle(.TITLE_SETTINGS)
            }
        }
    }
}
