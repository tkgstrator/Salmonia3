//
//  LoggingThread.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/24.
//

import SwiftUI

struct LoggingThread: View {
    var body: some View {
        GeometryReader(content: { geometry in
            DeveloperCredit
                .position(x: geometry.frame(in: .local).midX, y: 80)
        })
    }
    
    var DeveloperCredit: some View {
        LazyVGrid(columns: Array(repeating: .init(), count: 2), alignment: .center, spacing: nil, pinnedViews: [], content: {
            Section(header: Text("Startup Projects").overlay(
                        Rectangle().frame(height: 1).offset(x: 0, y: -2), alignment: .bottom), content: {
                Link(destination: URL(string: "https://twitter.com/Yukinkling")!, label: {
                    Text("Yukinkling")
                })
                Link(destination: URL(string: "https://twitter.com/barley_ural")!, label: {
                    Text("barley_ural")
                })
            })
            Section(header: Text("External API").overlay(
                        Rectangle().frame(height: 1).offset(x: 0, y: -2), alignment: .bottom), content: {
                Link(destination: URL(string: "https://twitter.com/frozenpandaman")!, label: {
                    Text("eli fessler")
                })
                Link(destination: URL(string: "https://twitter.com/NexusMine")!, label: {
                    Text("NexusMine")
                })
            })
            Section(header: Text("UI Design").overlay(
                        Rectangle().frame(height: 1).offset(x: 0, y: -2), alignment: .bottom), content: {
                Link(destination: URL(string: "https://twitter.com/sasapiyogames")!, label: {
                    Text("sasapiyogames")
                })
                Link(destination: URL(string: "https://twitter.com/lemon0617tea")!, label: {
                    Text("lemontea")
                })
            })
        })
    }
}

struct LoggingThread_Previews: PreviewProvider {
    static var previews: some View {
        LoggingThread()
    }
}
