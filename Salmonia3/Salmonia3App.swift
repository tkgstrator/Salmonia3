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
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.lineLimit, 1)
                .environment(\.minimumScaleFactor, 0.5)
                .environment(\.imageScale, .large)
                .environment(\.textCase, nil)
                .animation(.easeInOut)
                .transition(.opacity)
                .listStyle(GroupedListStyle())
                .buttonStyle(PlainButtonStyle())
        }
    }
}
