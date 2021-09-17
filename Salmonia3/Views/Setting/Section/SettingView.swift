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
        List {
            Sections.Account()
            Sections.SalmonStats()
            Sections.Product()
            Sections.Appearance()
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
