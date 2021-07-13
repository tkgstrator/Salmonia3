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
import KeychainAccess

// SwiftyBeaverの初期化
let log = SwiftyBeaver.self
let console = ConsoleDestination()
let file = FileDestination()
let cloud = SBPlatformDestination(appID: "k6Pxwd", appSecret: "iqnaqabvjpwGitdb6au4wDo0UphgshBz", encryptionKey: "vb8cesft69mtFmPbeRe8iIuXohHbrmno")
// Salmon Statsインスタンスの初期化
var manager: SalmonStats = SalmonStats()

@main
struct Salmonia3App: App {
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
    private var task = Set<AnyCancellable>()
    
    // 旧データを削除するためのコード
    private func getKeychain() {
        for item in Keychain.allItems(.internetPassword) {
            print(item)
            if let value = item["server"] as? String {
                if value == "" {
                    if let key = item["key"] as? String {
                        if key == "sessionToken" {
                            if let sessionToken = item["value"] as? String {
                                manager.getCookie(sessionToken: sessionToken)
                                    .receive(on: DispatchQueue.main)
                                    .sink(receiveCompletion: { completion in
                                        switch completion {
                                        case .finished:
                                            let keychain = Keychain(server: "tkgstrator.work", protocolType: .https)
                                            try? keychain.removeAll()
                                        case .failure(let error):
                                            print(error)
                                        }
                                    }, receiveValue: { response in
                                        print(response)
                                    }).store(in: &task)
                            }
                        }
                    }
                }
            }
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
        getKeychain()
        
        // MARK: シフト情報の取得
        try? RealmManager.addNewRotation(from: SplatNet2.shiftSchedule)
        return true
    }
}
