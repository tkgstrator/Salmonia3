//
//  LoggingThread.swift
//  Salmonia3
//
//  Created by tkgstrator on 3/13/21.
//

import Foundation
import SwiftUI
import MBCircleProgressBar

struct LoggingThread: View {
    @ObservedObject var progressModel: MBCircleProgressModel
    @Environment(\.presentationMode) var present

    var body: some View {
        VStack {
            Credit
            Divider()
            MBCircleProgressView(data: progressModel)
                .frame(width: 200, height: 200, alignment: .center)
                .overlay(LoadingIndicator(loading: !progressModel.isCompleted), alignment: .bottom)
            Spacer()
        }
        .onChange(of: progressModel.isCompleted) { value in
            if value { present.wrappedValue.dismiss() }
        }
        .onAppear(perform: enableAutoLock)
        .onDisappear(perform: disableAutoLock)
        .navigationTitle(.TITLE_LOGGING_THREAD)
        .navigationBarBackButtonHidden(!progressModel.isCompleted)
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
