//
//  ContentView.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/11.
//

import SwiftUI
import SwiftyUI

struct ContentView: View {
    @EnvironmentObject var appManager: AppManager
    
    var body: some View {
        NavigationView {
            TopMenu()
            SettingView()
        }
        .preferredColorScheme(appManager.isDarkMode ? .dark : .light)
        .fullScreenCover(isPresented: $appManager.isFirstLaunch) {
            NavigationView {
                LoginMenu()
            }
        }
        .overlay(GoobleMobileAdsView(isAvailable: !appManager.isPaid02, adUnitId: "ca-app-pub-7107468397673752/3033508550"), alignment: .bottom)
        .navigationViewStyle(SplitNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
