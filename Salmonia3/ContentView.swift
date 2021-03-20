//
//  ContentView.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/11.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var main: CoreAppSetting

    var body: some View {
        NavigationView {
            TopMenu()
            SettingView()
        }
        .padding(.bottom, 50)
        .overlay(GoobleMobileAdsView().backgroundColor(.clear), alignment: .bottom)
        .navigationViewStyle(LegacyNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
