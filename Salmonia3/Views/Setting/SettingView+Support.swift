//
//  SettingView+Support.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/01.
//

import SwiftUI

struct SettingView_Support: View {
    var body: some View {
        Section(content: {
            NavigationLink(destination: SupportView(), label: {
                Text("アプリを応援する")
            })
        }, header: {
            Text("サポート")
        }, footer: {
            Text("アプリを応援すると開発者のやる気が増えます")
        })
    }
}

struct SettingView_Support_Previews: PreviewProvider {
    static var previews: some View {
        SettingView_Support()
    }
}
