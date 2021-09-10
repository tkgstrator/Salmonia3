//
//  LoggingThread.swift
//  Salmonia3
//
//  Created by tkgstrator on 3/13/21.
//

import Foundation
import SwiftUI
import Introspect

struct LoggingThread: View {
    @Environment(\.presentationMode) var present
    var currentValue: Int = 30
    var maxValue: Int = 100
    
    init(currentValue: Int, maxValue: Int) {
        self.currentValue = currentValue
        self.maxValue = maxValue
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            LazyVStack(alignment: .center, spacing: nil, pinnedViews: [], content: {
                credit
            })
        }).introspectScrollView(customize: { scrollView in
            scrollView.isScrollEnabled = false
        })
        .overlay(circleProgress, alignment: .center)
        .background(Wave().edgesIgnoringSafeArea(.all))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle(.TITLE_LOGGING_THREAD)
    }
    
    var circleProgress: some View {
        Circle()
            .trim(from: 0.0, to: CGFloat(currentValue) / CGFloat(maxValue))
            .stroke(Color.whitesmoke, lineWidth: 15)
            .rotationEffect(.degrees(-90))
            .frame(width: 200, height: 200)
            .background(Circle()
                        .stroke(Color.envy, lineWidth: 15)
                        .frame(width: 200, height: 200))
            .overlay(Circle().fill(Color.safetyorange.opacity(0.5)).frame(width: 185, height: 185))
            .background(Circle().fill(Color.white))
    }

    var credit: some View {
        LazyVStack {
            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 130)), count: 2), alignment: .center, spacing: nil, pinnedViews: [], content: {
//                Section(header: Text("Developer").font(.custom("Splatfont2", size: 18)), content: {
//                    Link(destination: URL(string: "https://twitter.com/tkgling")!, label: {
//                        Text("tkgling")
//                    })
//                })
                Section(header: Text("Startup Projects").font(.custom("Splatfont2", size: 19)).frame(width: 260).overlay(
                            Rectangle().frame(height: 1).offset(x: 0, y: -2), alignment: .bottom), content: {
                    Link(destination: URL(string: "https://twitter.com/Yukinkling")!, label: {
                        Text("Yukinkling")
                    })
                    Link(destination: URL(string: "https://twitter.com/barley_ural")!, label: {
                        Text("barley_ural")
                    })
                })
                Section(header: Text("External API").font(.custom("Splatfont2", size: 19)).frame(width: 260).overlay(
                            Rectangle().frame(height: 1).offset(x: 0, y: -2), alignment: .bottom), content: {
                    Link(destination: URL(string: "https://twitter.com/frozenpandaman")!, label: {
                        Text("eli fessler")
                    })
                    Link(destination: URL(string: "https://twitter.com/NexusMine")!, label: {
                        Text("NexusMine")
                    })
                })
                Section(header: Text("UI Design").font(.custom("Splatfont2", size: 19)).frame(width: 260).overlay(
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
        .padding()
        .font(.custom("Splatfont2", size: 16))
        .foregroundColor(.whitesmoke)
    }
    
    private func enableAutoLock() {
        UIApplication.shared.isIdleTimerDisabled = true
    }

    private func disableAutoLock() {
        UIApplication.shared.isIdleTimerDisabled = false
    }
}

struct LoggingThread_Previews: PreviewProvider {
    static var previews: some View {
        LoggingThread(currentValue: 30, maxValue: 100)
    }
}
