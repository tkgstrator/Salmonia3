//
//  SettingView+Appearance.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/24.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI

struct SettingView_Appearance: View {
    @EnvironmentObject var service: AppService
    
    var body: some View {
        Section(content: {
            Toggle(isOn: $service.apperances.isDarkmode, label: {
                Text("ダークモードを使う")
            })
        }, header: {
            Text("外観")
        }, footer: {
            Text("アプリの外観を変更します")
        })
    }
}
