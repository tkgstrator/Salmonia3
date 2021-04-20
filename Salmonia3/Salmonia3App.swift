//

//  Salmonia3App.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/11.
//

import SwiftUI
import UIKit
import Firebase
import AdSupport
import AppTrackingTransparency
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        RealmManager.migration()
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in
//            GADMobileAds.sharedInstance().start(completionHandler: nil)
            print(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        })
        return true
    }
}

@main
struct Salmonia3App: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
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
                .environmentObject(CoreRealmCoop())
                .environmentObject(CoreAppProduct())
                .environmentObject(AppSettings())
                .listStyle(GroupedListStyle())
                .buttonStyle(PlainButtonStyle())
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .animation(.easeInOut)
                .transition(.opacity)
        }
    }
}
