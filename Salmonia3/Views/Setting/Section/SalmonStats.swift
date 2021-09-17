//
//  SalmonStats.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/15.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI

extension Setting.Sections {
    struct SalmonStats: View {
        @State var isPresented: Bool = false
        @State var isActive: Bool = false
        
        var body: some View {
            Section(header: Text(.HEADER_SALMONSTATS).splatfont2(.safetyorange, size: 14),
                    footer: Text(.FOOTER_SALMONSTATS).splatfont2(.secondary, size: 13).environment(\.lineLimit, 2)) {
                SettingMenu(title: .SETTING_UPLOAD, value: !(manager.apiToken?.isEmpty ?? true))
                    .overlay(NavigationLink(destination: ImportingView(), isActive: $isActive, label: { EmptyView() }))
                Button(action: { isPresented.toggle() }, label: { Text(.SETTING_IMPORT_RESULT) })
                    .alert(isPresented: $isPresented) {
                        Alert(title: Text(.TEXT_CONFIRM),
                              message: Text(.TEXT_IMPORT),
                              primaryButton: .default(Text(.BTN_CONFIRM), action: { isActive.toggle() }),
                              secondaryButton: .destructive(Text(.BTN_CANCEL)))
                    }
                NavigationLink(destination: UsernameView(), label: { Text(.SETTING_UPDATE_NAME)})
            }
        }
    }
}
