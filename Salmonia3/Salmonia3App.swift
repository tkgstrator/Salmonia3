//
//  Salmonia3App.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/19.
//

import SwiftUI

@main
struct Salmonia3App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppManager())
        }
    }
}
