//
//  ImportingView.swift
//  Salmonia3
//
//  Created by devonly on 2021/04/18.
//

import SwiftUI
import Combine
import SalmonStats
import SplatNet2
import MBCircleProgressBar

struct ImportingView: View {
    @Environment(\.presentationMode) var present
    @State var task = Set<AnyCancellable>()
    @State var progressModel = MBCircleProgressModel(progressColor: .blue, emptyLineColor: .gray)

    var body: some View {
        LoggingThread(progressModel: $progressModel)
            .onAppear {
                if let nsaid = SplatNet2.shared.playerId {
                    importResultFromSalmonStats(nsaid: nsaid)
                }
            }
            .navigationTitle("TITLE_IMPORT_SALMONSTATS")
    }
    
    private func importResultFromSalmonStats(nsaid: String) {
        SalmonStats.shared.getMetadata(nsaid: nsaid)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
            }, receiveValue: { metadata in
                for userdata in metadata {
                    progressModel.maxValue = CGFloat(userdata.results.clear + userdata.results.fail)
                    let lastPageId: Int = Int((userdata.results.clear + userdata.results.fail) / 50) + 1
                    for pageId in Range(1 ... lastPageId) {
                        SalmonStats.shared.getResults(nsaid: userdata.playerId, pageId: pageId)
                            .receive(on: DispatchQueue.main)
                            .sink(receiveCompletion: { completion in
                                switch completion {
                                case .finished:
                                    print("FINISHED")
                                case .failure(let error):
                                    print(error)
                                }
                            }, receiveValue: { results in
                                progressModel.value += CGFloat(results.count)
                                RealmManager.addNewResultsFromSalmonStats(from: results, pid: nsaid)
                            })
                            .store(in: &task)
                    }
                }
            })
            .store(in: &task)
    }
}

struct ImportingView_Previews: PreviewProvider {
    static var previews: some View {
        ImportingView()
    }
}
