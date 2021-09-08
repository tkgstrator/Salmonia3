//
//  ImportingView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/04/18.
//

import SwiftUI
import Combine
import SalmonStats
import SplatNet2

struct ImportingView: View {
    @EnvironmentObject var appManager: AppManager
    @Environment(\.presentationMode) var present
    @State var task = Set<AnyCancellable>()
    @State var apiError: APIError? = nil
    
    var body: some View {
        Text("Nyamo")
            .onAppear(perform: importResultFromSalmonStats)
            .navigationTitle(.TITLE_LOGGING_THREAD)
    }
    
    private func importResultFromSalmonStats() {
        let dispatchQueue = DispatchQueue(label: "Network Publisher")

        manager.getMetadata(nsaid: manager.playerId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    apiError = error
                }
            }, receiveValue: { response in
                DispatchQueue.main.async {
                    #if DEBUG
                    let maxValue: CGFloat = 500
                    #else
                    let maxValue: CGFloat = CGFloat(response.map{ $0.results.clear + $0.results.fail }.reduce(0, +))
                    #endif
                    
                    #if DEBUG
                    let lastPageId: Int = 10
                    #else
                    let lastPageId: Int = Int(maxValue / 50) + 1
                    #endif
                    
                    for pageId in Range(1 ... lastPageId) {
                        manager.getResults(nsaid: manager.playerId, pageId: pageId, count: 50)
                            .receive(on: DispatchQueue.main)
                            .sink(receiveCompletion: { completion in
                                switch completion {
                                case .finished:
                                    break
                                case .failure(let error):
                                    apiError = error
                                }
                            }, receiveValue: { response in
                                DispatchQueue.main.async {
                                }
                                RealmManager.shared.addNewResultsFromSplatNet2(from: response, .salmonstats)
                            }).store(in: &task)
                    }
                }
            }).store(in: &task)
    }
}

struct ImportingView_Previews: PreviewProvider {
    static var previews: some View {
        ImportingView()
    }
}
