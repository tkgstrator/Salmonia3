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

    var body: some View {
        Form {
            Sections.Account()
            Sections.SalmonStats()
            Sections.Product()
            Sections.Appearance()
            Section(header: Text(.SETTING_DETAIL).splatfont2(.safetyorange, size: 14), content: {
                NavigationLink(destination: Sections.Detail(), label: {
                    Text(.SETTING_DETAIL)
                })
            })
        }
        .font(.custom("Splatfont2", size: 16))
        .navigationTitle(.TITLE_SETTINGS)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
