//
//  Salmonia3App.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/11.
//

import SwiftUI
import Firebase
import AdSupport
import AppTrackingTransparency
import GoogleMobileAds

@main
struct Salmonia3App: App {
    init() {
        #warning("AppDelegateの代わり")
        FirebaseApp.configure()
        RealmManager.migration()
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        })
        print(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
    }
    
    @AppStorage("isFirstLaunch") var isFirstLaunch = true
    @AppStorage("isDarkMode") var isDarkMode = false
    var body: some Scene {
        WindowGroup {
            ContentView()
                .fullScreenCover(isPresented: $isFirstLaunch) {
                    NavigationView {
                        LoginMenu()
                    }
                }
                .environment(\.lineLimit, 1)
                .environment(\.minimumScaleFactor, 0.5)
                .environment(\.imageScale, .large)
                .environment(\.textCase, nil)
                .animation(.easeInOut)
                .transition(.opacity)
                .environmentObject(CoreRealmCoop())
                .environmentObject(CoreAppSetting())
                .listStyle(GroupedListStyle())
                .buttonStyle(PlainButtonStyle())
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
