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
        switch UserDefaults.standard.FEATURE_FREE_05 {
            case true:
            AF.request("https://api.splatnet2.com/version", method: .get)
                .validate(statusCode: 200...200)
                .validate(contentType: ["application/json"])
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        let decoder: JSONDecoder = {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            return decoder
                        }()
                        guard let data = response.data else { return }
                        
                        guard let response = try? decoder.decode(XProductVersion.self, from: data) else { return }
                        UserDefaults.standard.setValue(response.xProductVersion, forKey: "APP_X_PRODUCT_VERSION")
                        UserDefaults.standard.setValue(response.apiVersion, forKey: "APP_API_VERSION")
                        manager = SalmonStats(version: response.xProductVersion)
                    case .failure(let error):
                        log.error(error.localizedDescription)
                    }
                }
            case false:
                let xProductVersion: String = "1.13.0"
                let apiVersion: String = "20211001"
                UserDefaults.standard.setValue(xProductVersion, forKey: "APP_X_PRODUCT_VERSION")
                UserDefaults.standard.setValue(apiVersion, forKey: "APP_API_VERSION")
                manager = SalmonStats(version: xProductVersion)
        }
    }
   
    /// SwiftyBeaverを初期化
    private func initSwiftyBeaver() {
        // MARK: SwiftyBeaverの設定
        console.format = "$DHH:mm:ss$d $L $M"
        log.addDestination(console)
        log.addDestination(cloud)
    }
    
    /// SwiftyStoreKitを初期化
    private func initSwiftyStoreKit() {
        /// 購入中処理があれば処理を完了させる
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

    private struct XProductVersion: Codable {
        let xProductVersion: String
        let apiVersion: String
    }
    
}
