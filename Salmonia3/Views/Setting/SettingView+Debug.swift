//
//  DebugView.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/01.
//

import SwiftUI
import SplatNet2

struct SettingView_Debug: View {
    @EnvironmentObject var service: AppService
    
    var body: some View {
        Section(content: {
            Button(action: {
                service.session.account?.credential.iksmSession.removeAll()
            }, label: {
                Text("Delete IksmSession")
            })
            Button(action: {
                service.session.setXProductVersion(version: "1.13.1")
            }, label: {
                Text("Set Previous X-Product Version")
            })
            Button(action: {
                service.registerTestData()
            }, label: {
                Text("Upload Test Data")
            })
            Button(action: {
            }, label: {
                Text("Update With Increment")
            })
        })
    }
}

struct SettingView_Debug_Previews: PreviewProvider {
    static var previews: some View {
        SettingView_Debug()
    }
}
