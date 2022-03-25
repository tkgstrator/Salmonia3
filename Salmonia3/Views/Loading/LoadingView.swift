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
            .onReceive(NotificationCenter.default.publisher(for: .didFinishedLoadResults), perform: { _ in
                dismiss()
            })
            .onReceive(NotificationCenter.default.publisher(for: .didFinishedLoadResultsWithError), perform: { response in
                if let sp2Error = response.object as? SP2Error {
                    self.sp2Error = sp2Error
                    isPresented.toggle()
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

private struct ProgressCircleView: View {
    let current: Int
    let maximum: Int
    
    var value: CGFloat {
        if maximum == .zero {
            return .zero
        }
        return CGFloat(current) / CGFloat(maximum)
    }
    
    var body: some View {
        ZStack(content: {
            Circle()
                .trim(from: 0.0, to: value)
                .stroke(Color.white, lineWidth: 8)
                .rotationEffect(.degrees(-90))
                .frame(width: 140, height: 140, alignment: .center)
                .animation(.linear, value: current)
            Circle()
                .stroke(Color.white.opacity(0.5), lineWidth: 8)
                .frame(width: 140, height: 140, alignment: .center)
            Text(String(format: "%02d/%02d", current, maximum))
                .font(systemName: .ShareTechMono, size: 28, foregroundColor: .white)
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
