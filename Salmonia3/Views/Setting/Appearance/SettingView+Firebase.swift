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
            if service.user == nil {
                Button(action: {
                    service.twitterSignIn()
                }, label: {
                    Text("連携する")
                })
            } else {
                Button(action: {
                    service.register()
                }, label: {
                    Text("リザルトを同期")
                })
                    .disabled(service.uploaded)
            }
        }, header: {
            Text("New Salmon Stats")
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
