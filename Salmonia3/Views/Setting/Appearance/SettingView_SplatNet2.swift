//
//  SettingView_SplatNet2.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/24.
//

import SwiftUI

struct SettingView_SplatNet2: View {
    @EnvironmentObject var service: AppService
    
    var body: some View {
        Section(content: {
            SignInView()
            AccountView()
            HStack(content: {
                Text("フレンドコード")
                Spacer()
                Text(service.account?.friendCode ?? "未取得")
                    .foregroundColor(.secondary)
            })
            Button(action: {
//                service.getFriendActivityList()
            }, label: {
                Text("アクティビティ")
            })
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
