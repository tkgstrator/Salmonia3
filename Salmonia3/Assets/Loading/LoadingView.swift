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

struct LoadingView: View {
    @Environment(\.presentationMode) var present
    @EnvironmentObject var user: CoreAppSetting
    @State var data: ProgressData = ProgressData()
    @State var isPresented: Bool = false
    @State var appError: APPError?
    
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
                    guard let pid: String = user.account.nsaid else { throw APPError.empty }
                    let jobNumLocal: Int = user.account.jobNum
                    
                    DispatchQueue(label: "Loading from SplatNet2").async {
                        do {
                            if !SplatNet2.isValid(iksm_session: iksmSession) {
                                let response: JSON = try SplatNet2.genIksmSession(sessionToken)
                                if let session = response["iksm_session"].string {
                                    RealmManager.setIksmSession(iksmSession: session, pid: pid)
                                    iksmSession = session
                                }
                            }
                            
                            let summary: JSON = try SplatNet2.getSummary(iksm_session: iksmSession)
                            guard let jobNumRemote: Int = summary["summary"]["card"]["job_num"].int else { throw APPError.unknown }
                            if jobNumLocal == jobNumRemote { throw APPError.nodata }
                            
                            #if DEBUG
                            let jobNumRange: Range<Int> = Range(jobNumRemote - 30 ... jobNumRemote)
                            #else
                            let jobNumRange: Range<Int> = Range(max(jobNumRemote - 49, jobNumLocal + 1) ... jobNumRemote)
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
                            try RealmManager.addNewResult(from: results)
                            DispatchQueue.main.async {
                                present.wrappedValue.dismiss()
                            }
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
                Alert(title: Text("ALERT_ERROR"), message: Text(appError!.errorDescription!.localized), dismissButton: .default(Text("BTN_DISMISS"), action: { present.wrappedValue.dismiss() }))
            }
    }
}
