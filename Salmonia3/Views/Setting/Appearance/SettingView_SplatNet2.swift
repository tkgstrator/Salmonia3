//
//  SettingView_SplatNet2.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/24.
//

import SwiftUI

struct SettingView_SplatNet2: View {
    var body: some View {
        Section(content: {
            SignInView()
            AccountView()
        }, header: {
            Text("イカリング2")
        }, footer: {
            Text("イカリング2のアカウントでログインします")
        })
    }
}

struct SettingView_SplatNet2_Previews: PreviewProvider {
    static var previews: some View {
        SettingView_SplatNet2()
    }
}
