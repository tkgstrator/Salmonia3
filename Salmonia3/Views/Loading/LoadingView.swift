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

struct LoadingView: View {
    @EnvironmentObject var service: AppService
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        LoggingThread()
            .overlay(CircleProgressView(progress: service.progress))
            .background(BackgroundWave())
            .onAppear(perform: {
                service.loadResultsFromSplatNet2()
            })
            .onDisappear(perform: {
                service.progress = nil
            })
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
            .environmentObject(AppService())
    }
}
