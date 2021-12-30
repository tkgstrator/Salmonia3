//
//  Salmonia3App.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/19.
//

import SwiftUI
import Firebase
import SplatNet2

@main
struct Salmonia3App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppManager())
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        if let manager = LogManager.shared {
            #if DEBUG
            manager.logLevel = .debug
            #else
            manager.logLevel = .info
            #endif
        }
        FirebaseApp.configure()
        return true
    }
}
