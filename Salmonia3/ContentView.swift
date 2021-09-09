//
//  ContentView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/03/11.
//

import SwiftUI
import SwiftyUI

struct ContentView: View {
    @EnvironmentObject var appManager: AppManager
    
    var body: some View {
        NavigationView {
            SalmoniaView()
            SettingView()
        }
        .fullScreenCover(isPresented: $appManager.isSignedIn, content: {
            NavigationView {
                LoginMenu()
            }
        })
        .preferredColorScheme(appManager.isDarkMode ? .dark : .light)
        .overlay(GoobleMobileAdsView(isAvailable: !appManager.isPaid01, adUnitId: "ca-app-pub-7107468397673752/3033508550"), alignment: .bottom)
        .navigationViewStyle(SplitNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
