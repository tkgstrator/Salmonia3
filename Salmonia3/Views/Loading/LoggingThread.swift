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
            Section(content: {
                Link(destination: URL(string: "https://twitter.com/Yukinkling")!, label: {
                    Text("Yukinkling")
                })
                Link(destination: URL(string: "https://twitter.com/barley_ural")!, label: {
                    Text("barley_ural")
                })
            }, header: {
                Text("CREDIT.STARTUP.PROJECT", comment: "プロジェクト")
                    .overlay(Rectangle().frame(height: 1).offset(x: 0, y: -2), alignment: .bottom)
            })
            Section(content: {
                Link(destination: URL(string: "https://twitter.com/frozenpandaman")!, label: {
                    Text("eli fessler")
                })
                Link(destination: URL(string: "https://twitter.com/NexusMine")!, label: {
                    Text("NexusMine")
                })
            }, header: {
                Text("CREDIT.EXTERNAL.API", comment: "外部API")
                    .overlay(Rectangle().frame(height: 1).offset(x: 0, y: -2), alignment: .bottom)
            })
            Section(content: {
                Link(destination: URL(string: "https://twitter.com/sasapiyogames")!, label: {
                    Text("sasapiyogames")
                })
                Link(destination: URL(string: "https://twitter.com/lemon0617tea")!, label: {
                    Text("lemontea")
                })
            }, header: {
                Text("CREDIT.DESIGN", comment: "UIデザイン")
                    .overlay(Rectangle().frame(height: 1).offset(x: 0, y: -2), alignment: .bottom)
            })
        })
    }
}

struct LoggingThread_Previews: PreviewProvider {
    static var previews: some View {
        LoggingThread()
    }
}
