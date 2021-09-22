//
//  DetailView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/05/19.
//

import SwiftUI
import LocalAuthentication


private struct LogoutButton: View {
    @EnvironmentObject var appManager: AppManager
    @State var isPresented: Bool = false
    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Text(.SETTING_SIGN_OUT)
        })
        .alert(isPresented: $isPresented, content: {
            Alert(title: Text(.SETTING_SIGN_OUT), message: Text(.TEXT_SIGN_OUT), primaryButton: .default(Text(.BTN_CONFIRM), action: {
                manager.deleteAllAccounts()
                appManager.isSignedIn.toggle()
            }), secondaryButton: .destructive(Text(.BTN_CANCEL)))
        })
    }
}

private struct EraseButton: View {
    @State var isPresented: Bool = false
    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Text(.SETTING_ERASE_DATA)
        })
        .alert(isPresented: $isPresented, content: {
            Alert(title: Text(.SETTING_ERASE_DATA), message: Text(.TEXT_ERASE_DATA), primaryButton: .default(Text(.BTN_CONFIRM), action: {
                try? RealmManager.shared.eraseAllRecord()
            }), secondaryButton: .destructive(Text(.BTN_CANCEL)))
        })
    }
}

extension Setting.Sections {
    struct Detail: View {
        @EnvironmentObject var appManager: AppManager

        var body: some View {
            List {
                Section(header: Text(.HEADER_PRIVACY).splatfont2(.safetyorange, size: 14)) {
                    Toggle(LocalizableStrings.Key.SETTING_LOG_SEND.rawValue.localized, isOn: $appManager.isDebugMode)
                }
                Section(header: Text(.HEADER_DATA).splatfont2(.safetyorange, size: 14)) {
                    EraseButton()
                    LogoutButton()
                }
            }
            .splatfont2(size: 16)
            .navigationTitle(.TITLE_SETTINGS)
        }
    }
}

extension Alert: Identifiable {
    public var id: UUID { UUID() }
}
