//
//  LoggingThread.swift
//  Salmonia3
//
//  Created by Devonly on 3/13/21.
//

import Foundation
import SwiftUI
import MBCircleProgressBar

struct LoggingThread: View {
    @ObservedObject var progressModel: MBCircleProgressModel

    var body: some View {
        VStack {
            Credit
            Divider()
            MBCircleProgressView(data: progressModel)
                .frame(width: 200, height: 200, alignment: .center)
                .overlay(LoadingIndicator(loading: !progressModel.isCompleted), alignment: .bottom)
            Spacer()
        }
        .navigationTitle(.TITLE_LOGGING_THREAD)
//        .navigationBarBackButtonHidden(true)
    }

    var Credit: some View {
        VStack {
            Text(verbatim: "Developed by @Herlingum")
            Text(verbatim: "Thanks @Yukinkling, @barley_ural")
            Text(verbatim: "API @frozenpandaman, @nexusmine")
        }
        .font(.custom("Roboto Mono", size: 16))
    }
}
