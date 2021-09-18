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
            .onAppear(perform: getResultFromSplatNet2)
            .alert(item: $apiError, content: { apiError in
                Alert(title: Text(apiError.error), message: Text(apiError.localizedDescription), dismissButton: .default(Text(.BTN_CONFIRM), action: { present.wrappedValue.dismiss() }))
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
                    print(response)
                })
                .store(in: &task)
        }
    }
    
    private func getNicknameIcons(pid: [String]) {
        manager.getNicknameAndIcons(playerId: Array(Set(pid))) { completion in
            switch completion {
            case .success(let response):
                RealmManager.shared.updateNicknameAndIcons(players: response)
            case .failure(let error):
                apiError = error
            }
        }
    }
    
    private func getResultFromSplatNet2() {
        #if DEBUG
        let latestJobId: Int = RealmManager.shared.getLatestResultId() - 3
        #else
        let latestJobId: Int = RealmManager.shared.getLatestResultId()
        #endif
        
        manager.getResultCoopWithJSON(latestJobId: latestJobId) { response in
            switch response {
            case .success(let results):
                RealmManager.shared.addNewResultsFromSplatNet2(from: results.data, .splatnet2)
                if let apiToken = apiToken {
                    uploadToSalmonStats(accessToken: apiToken, results: results.json.map({ $0.dictionaryObject! }))
                }
                getNicknameIcons(pid: results.data.flatMap({ $0.results.map({ $0.pid} )}))
            case .failure(let error):
                apiError = error
                appManager.loggingToCloud(error.localizedDescription)
            }
        }
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
