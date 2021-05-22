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
let cloud = SBPlatformDestination(appID: "work.tkgstrator.", appSecret: "salmonia3", encryptionKey: "salmonia3")

class AppDelegate: NSObject, UIApplicationDelegate {
    private var task = Set<AnyCancellable>()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // ログの設定
        console.format = "$DHH:mm:ss$d $L $M"

        log.addDestination(console)
        log.addDestination(file)
        log.addDestination(cloud)
        
        log.verbose("not so important")
        FirebaseApp.configure()

        ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in
            GADMobileAds.sharedInstance().start(completionHandler: nil)
            print(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        })
        
        
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
    @AppStorage("isFirstLaunch") var isFirstLaunch = true
    @AppStorage("isDarkMode") var isDarkMode = false
    @AppStorage("apiToken") var apiToken: String?

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
//                .animation(.easeInOut)
//                .transition(.opacity)
        }
    }
    
    private func updateApiToken() {
        if let apiToken = apiToken {
            SalmonStats.shared.configure(apiToken: apiToken)
        }
    }
}

fileprivate extension URL {
    var queryParameters: [String: Any] {
        guard let queries = URLComponents(string: absoluteString)?.queryItems else { return [:] }
        var parameters: [String: Any] = [:]
        
        for query in queries {
            parameters[query.name] = query.value == "true" ? true : false
        }
        return parameters
    }
}
