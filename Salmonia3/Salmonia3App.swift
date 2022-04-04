//
//  Salmonia3App.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/19.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftyUI
import Firebase
import AppTrackingTransparency
import GoogleMobileAds
import Common
import SwiftyStoreKit
import CocoaLumberjackSwift
import RealmSwift

private let schemeVersion: UInt64 = 8192
internal let realm: Realm = {
    do {
        return try Realm()
    } catch {
        var config = Realm.Configuration.defaultConfiguration
        config.deleteRealmIfMigrationNeeded = true
        config.schemaVersion = schemeVersion
        return try! Realm(configuration: config, queue: nil)
    }
}()

@main
struct Salmonia3App: SwiftUI.App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppService())
        }
    }
}

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    func sceneDidBecomeActive(_ scene: UIScene) {
        /// IDFA対応の広告表示に必要
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            if #available(iOS 14.5, *) {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    GADMobileAds.sharedInstance().start(completionHandler: nil)
                })
            } else{
                GADMobileAds.sharedInstance().start(completionHandler: nil)
            }
        })
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
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // SwiftyStoreKitの初期化
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            DDLogInfo(purchases.count)
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                    case .purchased, .restored:
                        DDLogInfo(purchase)
                        if purchase.needsFinishTransaction {
                            // Deliver content from server, then:
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                        }
                        // Unlock content
                    case .failed, .purchasing, .deferred:
                        break // do nothing
                    @unknown default:
                        break // do nothing
                }
            }
        }
        return true
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
