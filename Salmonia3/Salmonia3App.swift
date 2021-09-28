//
//  Salmonia3App.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/03/11.
//

import SwiftUI
import UIKit
import Firebase
import AdSupport
import Alamofire
import AppTrackingTransparency
import GoogleMobileAds
import SplatNet2
import SalmonStats
import Combine
import SwiftyBeaver
import RealmSwift
import KeychainAccess
import SwiftyStoreKit

// SwiftyBeaverの初期化
let log = SwiftyBeaver.self
let console = ConsoleDestination()
let file = FileDestination()
let cloud = SBPlatformDestination(appID: "k6Pxwd", appSecret: "iqnaqabvjpwGitdb6au4wDo0UphgshBz", encryptionKey: "vb8cesft69mtFmPbeRe8iIuXohHbrmno")

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
                .onAppear(perform: initFirebaseMobileAds)
        }
    }
    
    private func initFirebaseMobileAds() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in
                GADMobileAds.sharedInstance().start(completionHandler: nil)
            })
        })
        print(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        initSwiftyStoreKit()
        initSwiftyBeaver()
        updateKeychainAccess()
        updateXProductVersion()
        try? RealmManager.shared.addNewRotation(from: SplatNet2.shiftSchedule)
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func updateXProductVersion() {
        AF.request("https://h505nylwxl.execute-api.ap-northeast-1.amazonaws.com/dev/version", method: .get)
            .validate(statusCode: 200...200)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        let decoder: JSONDecoder = {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            return decoder
                        }()
                        
                        // APIのバージョンを更新
                        if let response = try? decoder.decode(XProductVersion.self, from: data) {
                            UserDefaults.standard.setValue(response.xProductVersion, forKey: "xProductVersion")
                            UserDefaults.standard.setValue(response.apiVersion, forKey: "apiVersion")
                            // インスタンスを更新
                            manager = SalmonStats(version: response.xProductVersion)
                        } else {
                        }
                    }
                case .failure(let error):
                    log.error(error.localizedDescription)
                }
            }
    }
    
    private func initSwiftyBeaver() {
        // MARK: SwiftyBeaverの設定
        console.format = "$DHH:mm:ss$d $L $M"
        log.addDestination(console)
        log.addDestination(cloud)
    }
    
    private func initSwiftyStoreKit() {
        // MARK: SwiftyStoreKitの設定
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                case .failed, .purchasing, .deferred:
                    log.error("SwiftyStoreKit: CompleteTransactions \(purchase.productId)")
                default:
                    break
                }
            }
        }
    }

    private func updateKeychainAccess() {
        // MARK: 旧バージョンからキーチェインを削除して更新する仕組み
        let servers: [String] = Keychain.allItems(.internetPassword).compactMap({ $0["key"] as? String }).filter({ !$0.isEmpty })
        if !servers.isEmpty {
            for server in servers {
                let keychain = Keychain(server: server, protocolType: .https)
                try? keychain.removeAll()
            }
            let keychain = Keychain(server: "tkgstrator.work", protocolType: .https)
            try? keychain.removeAll()
        }
    }
    
    private struct XProductVersion: Codable {
        let xProductVersion: String
        let apiVersion: String
    }
    
}
