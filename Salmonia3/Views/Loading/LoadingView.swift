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
    @EnvironmentObject var appManager: AppManager
    @Environment(\.dismiss) var dismiss
    @State var sp2Error: SP2Error?
    @State var task = Set<AnyCancellable>()
    
    var body: some View {
        LoggingThread()
            .background(BackgroundWave())
            .onAppear(perform: loadResultsFromSplatNet2)
            .alert(item: $sp2Error, content: { error in
                Alert(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("Dismiss"), action: { dismiss() }))
            })
    }
    
    func loadResultsFromSplatNet2() {
        appManager.uploadResults(resultId: 3580)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            self.dismiss()
                        })
                    case .failure(let error):
                        sp2Error = error
                }
            }, receiveValue: { response in
                appManager.save(response.map({ RealmCoopResult(from: $0.1, nsaid: appManager.account.nsaid, stats: $0.0) }))
                print(response)
            })
            .store(in: &task)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
