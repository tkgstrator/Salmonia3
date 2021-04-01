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
import SwiftyJSON
import Combine

struct LoadingView: View {
    @Environment(\.presentationMode) var present
    @EnvironmentObject var user: AppSettings
    @AppStorage("apiToken") var apiToken: String?
    @State var data: ProgressData = ProgressData()
    @State var isPresented: Bool = false
    @State var appError: APPError?
    @State private var task: [AnyCancellable?] = []
    
    private func dismiss() {
        DispatchQueue.main.async { present.wrappedValue.dismiss() }
    }
    
    var body: some View {
        LoggingThread(data: $data)
            .onAppear() {
                // DispatchQueue前のエラー処理
                do {
                    guard var iksmSession: String = user.account.iksmSession else { throw APPError.empty }
                    guard let sessionToken: String = user.account.sessionToken else { throw APPError.empty }
                    guard let nsaid: String = user.account.nsaid else { throw APPError.empty }
                    var jobId: (local: Int, remote: Int) = (user.account.jobNum, 0)
                    
                    DispatchQueue(label: "Loading from SplatNet2").async {
                        do {
                            if !SplatNet2.isValid(iksm_session: iksmSession) {
                                let response: JSON = try SplatNet2.genIksmSession(sessionToken)
                                try RealmManager.setIksmSession(nsaid: nsaid, account: response)
                                iksmSession = response["iksm_session"].stringValue
                            }
                            
                            // バイト概要を取得
                            let summary: JSON = try SplatNet2.getSummary(iksm_session: iksmSession)
                            
                            if let _jobId = summary["summary"]["card"]["job_num"].int {
                                #if DEBUG
                                jobId.remote = _jobId
                                #else
                                // ローカルと同じまたはリザルト数が0なら空エラーを返す
                                if _jobId == 0 || (_jobId == jobId.local) { throw APPError.empty }
                                jobId.remote = _jobId
                                #endif
                            } else {
                                // JSONが取得できなかった場合
                                throw APPError.unknown
                            }

                            #if DEBUG
//                            let jobNumRange: Range<Int> = Range(jobId.remote - 1 ... jobId.remote)
                            let jobNumRange: Range<Int> = Range(jobId.remote ... jobId.remote)
                            #else
                            let jobNumRange: Range<Int> = Range(max(jobId.remote, jobId.local + 1) ... jobId.remote)
                            #endif
                            
                            var results: [JSON] = []
                            for (_, jobId) in jobNumRange.enumerated() {
                                do {
                                    let result: JSON = try SplatNet2.getResult(job_id: jobId, iksm_session: iksmSession)
                                    Thread.sleep(forTimeInterval: 1)
                                    results.append(result)
                                    data.progress += 1 / CGFloat(jobNumRange.count)
                                } catch {
                                    appError = error as? APPError
                                    isPresented.toggle()
                                }
                            }
                            
                            if apiToken != nil {
                                for result in results.chunked(by: 10) {
                                    task.append(SalmonStatsAPI().uploadResultToSalmonStats(from: result.map{ $0.dictionaryObject! })
                                        .receive(on: DispatchQueue.main)
                                        .sink(receiveCompletion: { completion in
                                            switch completion {
                                            case .finished:
                                                print("SUCCESS")
                                            case .failure(let error):
                                                print("FAILURE", error)
                                            }
                                        }, receiveValue: { results in
                                            try? RealmManager.updateResult(from: results)
                                        }))
                                }
                            }

                            try RealmManager.addNewResult(from: results)
                            try RealmManager.updateUserInfo(pid: nsaid, summary: summary)
                            DispatchQueue.main.async { present.wrappedValue.dismiss() }
                        }
                        catch {
                            appError = error as? APPError
                            isPresented.toggle()
                        }
                    }
                } catch {
                    appError = error as? APPError
                    isPresented.toggle()
                }
            }
            .alert(isPresented: $isPresented) {
                Alert(title: Text("ALERT_ERROR"),
                      message: Text(appError?.errorDescription!.localized ?? "FATAL ERROR"),
                      dismissButton: .default(Text("BTN_DISMISS"),
                                              action: {
                                                DispatchQueue.main.async { present.wrappedValue.dismiss() }
                                              }))
            }
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
