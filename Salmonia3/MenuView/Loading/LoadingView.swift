//
//  LoadingView.swift
//  Salmonia3
//
//  Created by Devonly on 3/13/21.
//

import Foundation
import SwiftUI
import SplatNet2
import RealmSwift
import Combine

struct LoadingView: View {
    @Environment(\.presentationMode) var present
    @EnvironmentObject var user: AppSettings
    @AppStorage("apiToken") var apiToken: String?
    @State var data: ProgressData = ProgressData()
    
    @State var isPresented: Bool = false
    @State var apiError: APIError?
    @State private var task = Set<AnyCancellable>()

    private func dismiss() {
        DispatchQueue.main.async { present.wrappedValue.dismiss() }
    }

    var body: some View {
        LoggingThread(data: $data)
            .onAppear {
                getResultFromSplatNet2()
            }
            .alert(isPresented: $isPresented) {
                Alert(title: Text("ALERT_ERROR"),
                      message: Text(apiError?.localizedDescription ?? "ERROR"),
                      dismissButton: .default(Text("BTN_DISMISS"), action: { dismiss() }))
            }
    }
    
    private func getResultFromSplatNet2() {
        SplatNet2.shared.getSummaryCoop()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    isPresented.toggle()
                    apiError = error
                }
            }, receiveValue: { response in
                if RealmManager.getLatestResultId() != response.summary.card.jobNum {
                    let jobNum = response.summary.card.jobNum
                    let jobIds = Range(max(RealmManager.getLatestResultId() + 1, jobNum - 49) ... jobNum)
                    for jobId in jobIds {
                        SplatNet2.shared.getResultCoop(jobId: jobId)
                            .receive(on: DispatchQueue.main)
                            .sink(receiveCompletion: { completion in
                                switch completion {
                                case .finished:
                                    print("JOB ID", jobId, "FINISHED")
                                case .failure(let error):
                                    print("JOB ID", jobId, "ERROR", error)
                                }
                            }, receiveValue: { response in
                                RealmManager.addNewResultsFromSplatNet2(from: response, pid: SplatNet2.shared.playerId!)
                            })
                            .store(in: &task)
                    }
                }
            })
            .store(in: &task)
    }
}

extension Array {
    // 配列を指定した区切りにする
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}
