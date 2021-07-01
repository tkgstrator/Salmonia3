//
//  LoadingView.swift
//  Salmonia3
//
//  Created by Devonly on 3/13/21.
//

import Foundation
import SwiftUI
import SplatNet2
import SalmonStats
import RealmSwift
import MBCircleProgressBar
import Combine

struct LoadingView: View {
    @Environment(\.presentationMode) var present
    @EnvironmentObject var appManager: AppManager
    @AppStorage("apiToken") var apiToken: String?
    
    @State var apiError: APIError?
    @State private var task = Set<AnyCancellable>()
    @State var progressModel = MBCircleProgressModel(progressColor: .red, emptyLineColor: .gray)
    private let dispatchQueue: DispatchQueue = DispatchQueue(label: "LoadingView")
    
    var body: some View {
        LoggingThread(progressModel: progressModel)
            .onAppear(perform: getResultFromSplatNet2)
            .alert(item: $apiError) { error in
                Alert(title: Text("ALERT_ERROR"),
                      message: Text(error.localizedDescription),
                      dismissButton: .default(Text("BTN_DISMISS"), action: {
                        appManager.loggingToCloud(error.errorDescription!)
                        present.wrappedValue.dismiss()
                      }))
            }
    }
    
    private func uploadToSalmonStats(results: [[String: Any]]) {
        let results = results.chunked(by: 10)
        for result in results {
            SalmonStats.shared.uploadResults(results: result)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        apiError = error
                    }
                }, receiveValue: { _ in })
                .store(in: &task)
        }
    }
    
    private func getNicknameIcons(pid: [String]) {
        manager.getNicknameAndIcons(playerId: Array(Set(pid)))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    apiError = error
                }
            }, receiveValue: { response in
                RealmManager.updateNicknameAndIcons(players: response.nicknameAndIcons)
            })
            .store(in: &task)
    }
    
    private func getResultFromSplatNet2() {
        var pids: [String] = []
        var results: [(json: Response.ResultCoop, data: SplatNet2.Coop.Result)] = []

        manager.getSummaryCoop()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    apiError = error
                }
            }, receiveValue: { response in
                #if DEBUG
                let latestResultId = RealmManager.getLatestResultId() - 49
                #else
                let latestResultId = RealmManager.getLatestResultId()
                #endif
                if latestResultId == response.summary.card.jobNum {
                    apiError = APIError.emptySessionToken
                    return
                }
                
                let jobNum = response.summary.card.jobNum
                let jobIds = Range(max(latestResultId + 1, jobNum - 49) ... jobNum)
                progressModel.configure(maxValue: CGFloat(jobIds.count))
                for jobId in jobIds {
                    // MARK: リザルトのダウンロード
                    manager.getResultCoopWithJSON(jobId: jobId)
                        .receive(on: DispatchQueue.main)
                        .sink(receiveCompletion: { completion in
                            progressModel.addValue(value: 1)
                            switch completion {
                            case .finished:
                                break
                            case .failure(let error):
                                apiError = error
                            }
                        }, receiveValue: { response in
                            // MARK: Salmon Statsへのアップロード
                            if let _ = SalmonStats.shared.apiToken {
                                pids.append(contentsOf: response.data.results.map{ $0.pid })
                                results.append(response)
                                if results.count == jobIds.count {
                                    RealmManager.addNewResultsFromSplatNet2(from: results.map{ $0.data }, pid: manager.playerId!)
                                    uploadToSalmonStats(results: results.map{ $0.json.dictionaryObject! })
                                    getNicknameIcons(pid: pids)
                                }
                            }
                        })
                        .store(in: &task)
                }
                try? RealmManager.updateSummary(from: response)
            })
            .store(in: &task)
    }
}

extension Array {
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}

extension Response.ResultCoop {
    var dictionaryObject: [String: Any]? {
        var encoder: JSONEncoder {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return encoder
        }
        
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: [])).flatMap{ $0 as? [String: Any] }
    }
}
