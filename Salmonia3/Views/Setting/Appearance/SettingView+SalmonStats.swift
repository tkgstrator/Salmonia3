//
//  SettingView+SalmonStats.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/24.
//

import SwiftUI

struct SettingView_SalmonStats: View {
    var body: some View {
        Section(content: {
            SignInStatsView()
        }, header: {
            Text("Salmon Stats")
        }, footer: {
            Text("Salmon Statsと連携します")
        })
    }
}

struct SettingView_SalmonStats_Previews: PreviewProvider {
    static var previews: some View {
        SettingView_SalmonStats()
    }
}
