//
//  LoggingThread.swift
//  Salmonia3
//
//  Created by Devonly on 3/13/21.
//

import Foundation
import SwiftUI

struct LoggingThread: View {
    @Binding var data: ProgressData

    var body: some View {
        VStack {
            Credit
            Divider()
            MBCircleProgressBar(data: $data, lineWidth: 5, size: 250)
            Spacer()
        }
        .navigationTitle("TITLE_LOGGING_THREAD")
        .navigationBarBackButtonHidden(true)
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
