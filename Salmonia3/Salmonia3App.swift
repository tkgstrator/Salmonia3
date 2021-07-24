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
import SplatNet2
import SalmonStats
import Combine
import SwiftyBeaver
import RealmSwift
import KeychainAccess

// SwiftyBeaverの初期化
let log = SwiftyBeaver.self
let console = ConsoleDestination()
let file = FileDestination()
let cloud = SBPlatformDestination(appID: "k6Pxwd", appSecret: "iqnaqabvjpwGitdb6au4wDo0UphgshBz", encryptionKey: "vb8cesft69mtFmPbeRe8iIuXohHbrmno")
let schemaVersion: UInt64 = 8192
// Salmon Statsインスタンスの初期化
var manager: SalmonStats = SalmonStats()


@main
struct Salmonia3App: SwiftUI.App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.lineLimit, 1)
                .environment(\.minimumScaleFactor, 0.5)
                .environment(\.imageScale, .large)
                .environment(\.textCase, nil)
                .environmentObject(CoreRealmCoop())
                .environmentObject(AppManager())
                .listStyle(GroupedListStyle())
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true

    private func updateAppVersion() {
        let servers: [String] = Keychain.allItems(.internetPassword).compactMap({ $0["key"] as? String }).filter({ !$0.isEmpty })
        if !servers.isEmpty {
            for server in servers {
                let keychain = Keychain(server: server, protocolType: .https)
                try? keychain.removeAll()
            }
            let keychain = Keychain(server: "tkgstrator.work", protocolType: .https)
            try? keychain.removeAll()
            isFirstLaunch = true
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // MARK: ログの設定
        console.format = "$DHH:mm:ss$d $L $M"
        
        log.addDestination(console)
        log.addDestination(file)
        log.addDestination(cloud)
        
        // MARK: Firebaseの設定
        FirebaseApp.configure()
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in
            GADMobileAds.sharedInstance().start(completionHandler: nil)
            print(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        })
        let config = Realm.Configuration(schemaVersion: schemaVersion, deleteRealmIfMigrationNeeded: true)
        Realm.Configuration.defaultConfiguration = config
        let _ = try! Realm()
        updateAppVersion()
        
        // MARK: シフト情報の取得
        try? RealmManager.addNewRotation(from: SplatNet2.shiftSchedule)
        return true
    }
}
