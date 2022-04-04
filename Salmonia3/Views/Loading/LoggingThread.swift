//
//  LoggingThread.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/24.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftyUI

struct LoggingThread: View {
    var body: some View {
        GeometryReader(content: { geometry in
            LazyVGrid(columns: Array(repeating: .init(), count: 2), alignment: .center, spacing: 12, content: {
                Section(content: {
                    Link(destination: URL(unsafeString: "https://twitter.com/tkgling"), label: {
                        Text("tkgling")
                    })
                    Link(destination: URL(unsafeString: "https://twitter.com/barley_ural"), label: {
                        Text("barley_ural")
                    })
                }, header: {
                    Text("Project")
                        .underline()
                        .font(systemName: .ShareTechMono, size: 16, foregroundColor: .white)
                })
                Section(content: {
                    Link(destination: URL(unsafeString: "https://twitter.com/frozenpandaman"), label: {
                        Text("eli fessler")
                    })
                    Link(destination: URL(unsafeString: "https://twitter.com/NexusMine"), label: {
                        Text("NexusMine")
                    })
                }, header: {
                    Text("Special Thanks")
                        .underline()
                        .font(systemName: .ShareTechMono, size: 16, foregroundColor: .white)
                })
            })
            .font(systemName: .ShareTechMono, size: 14, foregroundColor: .white)
                .position(x: geometry.frame(in: .local).midX, y: 80)
        })
    }
}

struct LoggingThread_Previews: PreviewProvider {
    static var previews: some View {
        LoggingThread()
    }
}
