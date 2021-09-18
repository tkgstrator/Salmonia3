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
            /// データだけを削除
            Alert(title: Text(.SETTING_ERASE_DATA), message: Text(.TEXT_ERASE_DATA), primaryButton: .default(Text(.BTN_CONFIRM), action: {
                try? RealmManager.shared.eraseAllRecord()
            }), secondaryButton: .cancel()),
            /// アカウントをログアウト
            Alert(title: Text(.SETTING_SIGN_OUT), message: Text(.TEXT_SIGN_OUT), primaryButton: .default(Text(.BTN_CONFIRM), action: {
                manager.deleteAllAccounts()
                UserDefaults.standard.setValue(false, forKey: "FEATURE_OTHER_01")
            }), secondaryButton: .cancel()),
            Alert(title: Text(.SETTING_RE_SIGN_IN), message: Text(.TEXT_RE_SIGN_IN), primaryButton: .default(Text(.BTN_CONFIRM), action: {}), secondaryButton: .cancel()),
        ]
        @State var alertItem: Alert?
        
        /// 警告を出した上ですべてのアカウント情報を削除して再ログイン
        var signOutButton: some View {
            Button(action: {
                alertItem = alertItems[1]
            }, label: {
                Text(.SETTING_SIGN_OUT)
            })
        }

        /// すべてのデータを削除するボタン
        var eraseDataButton: some View {
            Button(action: {
                alertItem = alertItems[0]
            }, label: {
                Text(.SETTING_ERASE_DATA)
            })
        }
        
        var body: some View {
            Form {
                Section(header: Text(.HEADER_PRIVACY).splatfont2(.safetyorange, size: 14)) {
                    Toggle(LocalizableStrings.Key.SETTING_LOG_SEND.rawValue.localized, isOn: $appManager.isDebugMode)
                }
                Section(header: Text(.HEADER_DATA).splatfont2(.safetyorange, size: 14)) {
                    eraseDataButton
                    signOutButton
                }
            }
            .splatfont2(size: 16)
            .navigationTitle(.TITLE_SETTINGS)
            .alert(item: $alertItem, content: { alert in
                alert
            })
        }
    }
}

extension Alert: Identifiable {
    public var id: UUID { UUID() }
}
