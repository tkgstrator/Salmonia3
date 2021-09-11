//
//  LoadingView.swift
//  Salmonia3
//
//  Created by tkgstrator on 3/13/21.
//

import Foundation
import SwiftUI
import SplatNet2
import SalmonStats
import RealmSwift
import Combine

struct LoadingView: View {
    @Environment(\.presentationMode) var present
    @EnvironmentObject var appManager: AppManager
    @AppStorage("apiToken") var apiToken: String?

    @State var currentValue: Int = 0
    @State var maxValue: Int = 0
    @State var apiError: APIError?

    @State private var task = Set<AnyCancellable>()
    private let dispatchQueue: DispatchQueue = DispatchQueue(label: "LoadingView")
    
    var body: some View {
        LoggingThread(currentValue: currentValue, maxValue: maxValue)
            .onWillAppear {
                getResultFromSplatNet2()
            }
            .alert(item: $apiError, content: { apiError in
                Alert(title: "ERROR".localized, message: apiError.localizedDescription)
            })
    }
    
    private func uploadToSalmonStats(accessToken: String, results: [[String: Any]]) {
        let results = results.chunked(by: 10)
        for result in results {
            manager.uploadResults(accessToken: accessToken, results: result)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        apiError = error
                    }
                }, receiveValue: { response in
                })
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
                RealmManager.shared.updateNicknameAndIcons(players: response.nicknameAndIcons)
            })
            .store(in: &task)
    }
    
    private func getResultFromSplatNet2() {
        var pids: [String] = []
        var results: [(json: ResultCoop.Response, data: SplatNet2.Coop.Result)] = []
        #if DEBUG
        let lastJobId: Int = RealmManager.shared.getLatestResultId() - 10
        #else
        let lastJobId: Int = RealmManager.shared.getLatestResultId()
        #endif
        manager.getSummaryCoop(jobNum: lastJobId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    switch error {
                    case .nonewresults:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            present.wrappedValue.dismiss()
                        }
                    default:
                        apiError = error
                    }
                }
            }, receiveValue: { _ in
                let jobIds: Range = Range(uncheckedBounds: (max(lastJobId + 1, manager.account.coop.jobNum - 49), manager.account.coop.jobNum + 1))
                maxValue = jobIds.count
                for jobId in jobIds {
                    manager.getResultCoopWithJSON(jobId: jobId)
                        .receive(on: DispatchQueue.main)
                        .sink(receiveCompletion: { completion in
                            // 一つ処理が終わるとインクリメントする
                            DispatchQueue.main.async {
                                withAnimation() {
                                    currentValue += 1
                                }
                            }
                            switch completion {
                            case .finished:
                                break
                            case .failure(let error):
                                switch error {
                                case .notfound:
                                    // 404の場合はスルーする
                                    break
                                default:
                                    apiError = error
                                }
                            }
                        }, receiveValue: { response in
                            // 一緒に遊んだプレイヤーのIDを取得して追加
                            pids.append(contentsOf: response.data.results.map{ $0.pid })
                            results.append(response)
                            dispatchQueue.async {
                                // 全てのリクエストが終わったら
                                if currentValue == jobIds.count - 1 {
                                    // SplatNet2形式のリザルトをRealmに追加する
                                    RealmManager.shared.addNewResultsFromSplatNet2(from: results.map{ $0.data }, .splatnet2)
                                    // アクセストークンを使って書き込み
                                    
                                    if let accessToken = manager.apiToken {
                                        uploadToSalmonStats(accessToken: accessToken, results: results.compactMap{ $0.json.dictionaryObject })
                                    }
                                    getNicknameIcons(pid: pids)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                        present.wrappedValue.dismiss()
                                    }
                                }
                            }
                        })
                        .store(in: &task)
                }
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

extension ResultCoop.Response {
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
