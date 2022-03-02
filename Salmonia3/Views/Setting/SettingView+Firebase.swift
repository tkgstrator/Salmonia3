//
//  SettingView+Firebase.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/02.
//

import SwiftUI

struct SettingView_Firebase: View {
    @EnvironmentObject var service: AppService
    
    var body: some View {
        Section(content: {
            Button(action: {
                service.twitterSignIn()
            }, label: {
                Text("Firebase登録")
            })
            Button(action: {
                service.register()
            }, label: {
                Text("New Salmon Statsへ同期")
            })
        }, header: {
            Text("Firebase")
        }, footer: {
            Text("この機能は体験版です")
        })
    }
}

struct SettingView_Firebase_Previews: PreviewProvider {
    static var previews: some View {
        SettingView_Firebase()
    }
}
