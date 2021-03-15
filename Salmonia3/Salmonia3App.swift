//
//  Salmonia3App.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/11.
//

import SwiftUI
import Firebase

@main
struct Salmonia3App: App {
    init() {
        #warning("AppDelegateの代わり")
        RealmManager.migration()
        FirebaseApp.configure()
        print(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
    }
    
    @AppStorage("isFirstLaunch") var isFirstLaunch = true
    var body: some Scene {
        WindowGroup {
            ContentView()
                .sheet(isPresented: $isFirstLaunch) {
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
        }
    }
}
