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
    @EnvironmentObject var appManager: AppManager
    @Environment(\.presentationMode) var present
    @State var task = Set<AnyCancellable>()
    @State var progressModel = MBCircleProgressModel(progressColor: .blue, emptyLineColor: .gray)
    @State var apiError: APIError? = nil
    
    var body: some View {
        LoggingThread(progressModel: progressModel)
            .alert(item: $apiError) { error in
                Alert(title: Text(.ALERT_ERROR), message: Text(error.localizedDescription), dismissButton: .default(Text(.BTN_DISMISS), action: {
//                    appManager.loggingToCloud(error.errorDescription!)
                    present.wrappedValue.dismiss()
                }))
            }
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
                    progressModel.configure(maxValue: maxValue)
                    #else
                    let maxValue: CGFloat = CGFloat(response.map{ $0.results.clear + $0.results.fail }.reduce(0, +))
                    progressModel.configure(maxValue: maxValue)
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
                                    progressModel.addValue(value: CGFloat(response.count))
                                }
                                RealmManager.shared.addNewResultsFromSplatNet2(from: response, .salmonstats)
                            }).store(in: &task)
                    }
                }
            }).store(in: &task)
        
//        SalmonStats.shared.getMetadata(nsaid: nsaid)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    apiError = error
//                }
//            }, receiveValue: { metadata in
//                DispatchQueue.main.async {
//                    #if DEBUG
//                    let maxValue: CGFloat = 500
//                    progressModel.configure(maxValue: maxValue)
//                    #else
//                    let maxValue: CGFloat = CGFloat(metadata.map{ $0.results.clear + $0.results.fail }.reduce(0, +))
//                    progressModel.configure(maxValue: maxValue)
//                    #endif
//                }
//                for userdata in metadata {
//                    #if DEBUG
//                    let lastPageId: Int = 10
//                    #else
//                    let lastPageId: Int = Int((userdata.results.clear + userdata.results.fail) / appManager.importNum) + 1
//                    #endif
//                    for pageId in Range(1 ... lastPageId) {
//                        dispatchQueue.async {
//                            SalmonStats.shared.getResults(nsaid: userdata.playerId, pageId: pageId, count: appManager.importNum)
//                                .receive(on: dispatchQueue)
//                                .sink(receiveCompletion: { completion in
//                                    switch completion {
//                                    case .finished:
//                                        print("FINISHED")
//                                    case .failure(let error):
//                                        apiError = error
//                                    }
//                                }, receiveValue: { results in
//                                    DispatchQueue.main.async {
//                                        progressModel.addValue(value: CGFloat(results.count))
//                                        RealmManager.shared.addNewResultsFromSalmonStats(from: results, pid: nsaid)
//                                    }
//                                })
//                                .store(in: &task)
//                        }
//                    }
//                }
//            })
//            .store(in: &task)
    }
}

struct ImportingView_Previews: PreviewProvider {
    static var previews: some View {
        ImportingView()
    }
}
