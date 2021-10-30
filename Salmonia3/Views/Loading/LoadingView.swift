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
            .onAppear(perform: loadResultsFromSplatNet2)
    }
    
    func loadResultsFromSplatNet2() {
        appManager.getResultCoopWithJSON(latestJobId: 3580, promise: { completion in
            switch completion {
                case .success(let results):
                    appManager.save(results.data)
                    dismiss()
                case .failure(let error):
                    print(error)
            }
        })
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
