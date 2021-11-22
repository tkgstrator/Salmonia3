//
//  LoadingView.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/24.
//

import SwiftUI
import SplatNet2

struct LoadingView: View {
    @EnvironmentObject var appManager: AppManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        LoggingThread()
            .background(BackgroundWave())
    }
    
    func loadResultsFromSplatNet2() {
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
