//
//  AccountInfo.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/04.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet2

extension Setting.Sections {
    struct Account: View {
        @EnvironmentObject var appManager: AppManager
        
        var body: some View {
            Section(header: Text(.HEADER_USERINFO).splatfont2(.safetyorange, size: 14)) {
                switch appManager.isPaid02 {
                case true:
                    AccountPicker(manager: manager)
                case false:
                    SettingMenu(title: .SETTING_ACCOUNT, value: manager.account.nickname)
                }
                SettingMenu(title: .SETTING_SPLATNET2, value: manager.playerId)
                SettingMenu(title: .RESULTS, value: manager.account.coop.jobNum)
                #if DEBUG
                Button(action: {
                    manager.account.iksmSession = ""
                }, label: {
                    Text("ERASE ACCOUNT TOKEN")
                })
                #endif
            }
        }
    }
}
