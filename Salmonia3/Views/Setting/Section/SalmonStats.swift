//
//  SalmonStats.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/15.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftyUI

extension Setting.Sections {
    struct SalmonStats: View {

        var body: some View {
            Section(header: Text(.HEADER_SALMONSTATS).splatfont2(.safetyorange, size: 14)) {
                SettingMenu(title: .SETTING_UPLOAD, value: !(manager.apiToken?.isEmpty ?? true))
                SalmonStatsButton()
                UsernameButton()
            }
        }
    }
    
    private struct SalmonStatsButton: View {
        @State var isPresented: Bool = false
        @State var isActive: Bool = false
        
        var body: some View {
            Button(action: { isPresented.toggle() }, label: { Text(.SETTING_IMPORT_RESULT) })
                .alert(isPresented: $isPresented) {
                    Alert(title: Text(.TEXT_CONFIRM),
                          message: Text(.TEXT_IMPORT),
                          primaryButton: .default(Text(.BTN_CONFIRM), action: { isActive.toggle() }),
                          secondaryButton: .destructive(Text(.BTN_CANCEL)))
                }
                .present(isPresented: $isActive, transitionStyle: .flipHorizontal, presentationStyle: .fullScreen, content: {
                    ImportingView()
                        .environment(\.modalIsPresented, .constant(PresentationStyle($isActive)))
                })
        }
    }
    
    private struct UsernameButton: View {
        @State var isPresented: Bool = false
        @State var isActive: Bool = false
        
        var body: some View {
            Button(action: { isPresented.toggle() }, label: { Text(.SETTING_UPDATE_NAME) })
                .alert(isPresented: $isPresented) {
                    Alert(title: Text(.TEXT_CONFIRM),
                          message: Text(.TEXT_IMPORT),
                          primaryButton: .default(Text(.BTN_CONFIRM), action: { isActive.toggle() }),
                          secondaryButton: .destructive(Text(.BTN_CANCEL)))
                }
                .present(isPresented: $isActive, transitionStyle: .flipHorizontal, presentationStyle: .fullScreen, content: {
                    UsernameView()
                        .environment(\.modalIsPresented, .constant(PresentationStyle($isActive)))
                })
        }
    }
}
