//
//  SettingView_Application.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/24.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI

struct SettingView_Application: View {
    @EnvironmentObject var service: AppService
    
    var body: some View {
        Section(content: {
            Toggle(isOn: service.$requiredAPIToken, label: {
                Text("Salmon Statsへのアップロードを必須にする")
            })
            HStack(content: {
                Text("バージョン")
                Spacer()
                Text(service.application.appVersion)
                    .foregroundColor(.secondary)
            })
            HStack(content: {
                Text("イカリング")
                Spacer()
                Text(service.version)
                    .foregroundColor(.secondary)
            })
        }, header: {
            Text("アプリ")
        }, footer: {
            Text("アプリのバージョンなど")
        })
    }
}

struct SettingView_Application_Previews: PreviewProvider {
    static var previews: some View {
        SettingView_Application()
    }
}
