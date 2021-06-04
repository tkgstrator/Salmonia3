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

// SwiftyBeaverの初期化
let log = SwiftyBeaver.self
let console = ConsoleDestination()
let file = FileDestination()
let cloud = SBPlatformDestination(appID: "k6Pxwd", appSecret: "iqnaqabvjpwGitdb6au4wDo0UphgshBz", encryptionKey: "vb8cesft69mtFmPbeRe8iIuXohHbrmno")

class AppDelegate: NSObject, UIApplicationDelegate {
    private var task = Set<AnyCancellable>()
    
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
        
        // MARK: シフト情報の取得
        SplatNet2.shared.getShiftSchedule()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { response in
                try? RealmManager.addNewRotation(from: response)
            })
            .store(in: &task)
        return true
    }
}

@main
struct Salmonia3App: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("apiToken") var apiToken: String?

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
//                .onAppear(perform: updateToken)
        }
    }
//
//    private func updateToken() {
//        // APIトークンの設定
//        if let apiToken = apiToken {
//            SalmonStats.shared.configure(apiToken: apiToken)
//        }
//
//        // sessionTokenを強制追加
//        guard let _ = SplatNet2.shared.sessionToken else {
//            if let account = RealmManager.shared.realm.objects(RealmUserInfo.self).first {
//                if let sessionToken = account.sessionToken {
//                    SplatNet2.shared.configure(sessionToken: sessionToken)
//                }
//            }
//            return
//        }
//    }
}
