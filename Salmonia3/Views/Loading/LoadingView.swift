//
//  LoadingView.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/24.
//

import SwiftUI
import SplatNet2
import SalmonStats
import Combine
import SwiftyUI
import CocoaLumberjackSwift

struct LoadingView: View {
    @StateObject var service: LoadingService = LoadingService()
    @State private var sp2Error: SP2Error?
    @State private var isPresented: Bool = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        GeometryReader(content: { geometry in
            LoggingThread()
            ProgressCircleView(current: service.current, maximum: service.maximum)
                .position(geometry.center)
        })
            .background(BackgroundWave())
            .onAppear(perform: service.downloadResultsFromSplatNet2)
            .onReceive(NotificationCenter.default.publisher(for: .didFinishedLoadResults), perform: { _ in
                dismiss()
            })
            .onReceive(NotificationCenter.default.publisher(for: .didFinishedLoadResultsWithError), perform: { response in
                DDLogInfo(response)
                if let sp2Error = response.object as? SP2Error {
                    self.sp2Error = sp2Error
                    self.isPresented = true
                } else {
                    dismiss()
                }
            })
            .alert(isPresented: $isPresented, error: sp2Error, actions: { error in
                Button("OK", action: {
                    dismiss()
                })
            }, message: { error in
                Text(error.failureReason ?? "Unknown error.")
            })
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

extension GeometryProxy {
    var width: CGFloat {
        frame(in: .local).width
    }
    
    var height: CGFloat {
        frame(in: .local).height
    }
    
    var center: CGPoint {
        CGPoint(x: frame(in: .local).midX, y: frame(in: .local).midY)
    }
}
