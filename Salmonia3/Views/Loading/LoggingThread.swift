//
//  LoggingThread.swift
//  Salmonia3
//
//  Created by tkgstrator on 3/13/21.
//

import Foundation
import SwiftUI

struct LoggingThread: View {
    @Environment(\.presentationMode) var present

    var body: some View {
        VStack {
            Credit
            Divider()
            Spacer()
        }
        .onAppear(perform: enableAutoLock)
        .onDisappear(perform: disableAutoLock)
        .navigationTitle(.TITLE_LOGGING_THREAD)
    }

    var Credit: some View {
        VStack {
            Text(verbatim: "Developed by @Herlingum")
            Text(verbatim: "Thanks @Yukinkling, @barley_ural")
            Text(verbatim: "API @frozenpandaman, @nexusmine")
        }
        .font(.custom("Roboto Mono", size: 16))
    }
    
    private func enableAutoLock() {
        UIApplication.shared.isIdleTimerDisabled = true
    }

    private func disableAutoLock() {
        UIApplication.shared.isIdleTimerDisabled = false
    }
}
