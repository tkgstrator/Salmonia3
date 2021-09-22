//
//  SettingView.swift
//  Salmonia3
//
//  Created by tkgstrator on 3/14/21.
//

import SwiftUI
import SwiftyUI
import BetterSafariView
import SalmonStats
import SplatNet2

struct SettingView: View {
    typealias Sections = Setting.Sections
    @EnvironmentObject var appManager: AppManager

    var body: some View {
        List {
            Sections.Account()
            Sections.SalmonStats()
            Sections.Product()
            Sections.Appearance()
            Section(header: Text(.SETTING_DETAIL).splatfont2(.safetyorange, size: 14), content: {
                NavigationLink(destination: Sections.Detail(), label: {
                    Text(.SETTING_DETAIL)
                })
            })
            Sections.AppInformation()
        }
        .font(.custom("Splatfont2", size: 16))
        .navigationTitle(.TITLE_SETTINGS)
        .navigationBarItems(trailing: AddAccountButton())
        .onReceive(NotificationCenter.default.publisher(for: SplatNet2.account), perform: { notification in
            if let account = notification.object as? UserInfo {
                manager.account = account
                appManager.objectWillChange.send()
            }
        })
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
