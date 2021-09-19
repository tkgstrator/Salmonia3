//
//  LoggingThread.swift
//  Salmonia3
//
//  Created by tkgstrator on 3/13/21.
//

import Foundation
import SwiftUI
import Introspect
import SplatNet2
import SalmonStats

struct LoggingThread: View {
    @Environment(\.presentationMode) var present
    @State var currentValue: Int = 0
    @State var maxValue: Int = 0
    private let cirlceSize: CGSize = CGSize(width: 140, height: 140)
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            LazyVStack(alignment: .center, spacing: nil, pinnedViews: [], content: {
                credit
            })
        }).introspectScrollView(customize: { scrollView in
            scrollView.isScrollEnabled = false
        })
        .onReceive(NotificationCenter.default.publisher(for: SalmonStats.imported), perform: { notification in
            guard let progress = notification.object as? SplatNet2.Progress else { return }
            withAnimation(.easeInOut) {
                maxValue = progress.maxValue
                currentValue = progress.currentValue
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: SplatNet2.download), perform: { notification in
            guard let progress = notification.object as? SplatNet2.Progress else { return }
            withAnimation(.easeInOut) {
                maxValue = progress.maxValue
                currentValue = progress.currentValue
            }
        })
        .overlay(circleProgress, alignment: .center)
        .overlay(textProgress, alignment: .center)
        .background(Wave().edgesIgnoringSafeArea(.all))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .preferredColorScheme(.dark)
        .navigationTitle(.TITLE_LOGGING_THREAD)
    }
    
    var textProgress: some View {
        Text(String(format: "%02d/%02d", currentValue, maxValue))
            .font(.custom("Splatfont2", size: 22))
            .foregroundColor(.whitesmoke)
            .animation(nil)
    }
    
    var circleProgress: some View {
        Circle()
            .trim(from: 0.0, to: CGFloat(currentValue) / CGFloat(maxValue))
            .stroke(Color.whitesmoke, lineWidth: 10)
            .rotationEffect(.degrees(-90))
            .visible(currentValue != 0)
            .frame(cirlceSize)
            .background(Circle()
                        .stroke(Color.envy, lineWidth: 10)
                        .frame(cirlceSize))
            .overlay(Circle().fill(Color.safetyorange.opacity(0.5)).frame(width: cirlceSize.width - 10, height: cirlceSize.height - 10))
            .background(Circle().fill(Color.white))
    }

    var credit: some View {
        LazyVStack {
            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 130)), count: 2), alignment: .center, spacing: nil, pinnedViews: [], content: {
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
