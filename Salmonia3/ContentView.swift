//
//  ContentView.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/11.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var main: AppSettings

    var body: some View {
        NavigationView {
            TopMenu()
            SettingView()
        }
        .overlay(GoobleMobileAdsView(), alignment: .bottom)
        .navigationViewStyle(LegacyNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
