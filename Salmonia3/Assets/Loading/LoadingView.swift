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
    
    var body: some View {
        LoggingThread(data: $data)
            .onAppear() {
                guard let iksmSession: String = user.account.iksmSession else { return }
                guard let sessionToken: String = user.account.sessionToken else { return }
                let jobNumLocal: Int = user.account.jobNum
                
                DispatchQueue(label: "Loading from SplatNet2").async {
                    do {
                        let realm = try? Realm()
                        
                        if SplatNet2.isValid(iksm_session: iksmSession) {
                            let response: JSON = try SplatNet2.genIksmSession(sessionToken)
                            #warning("多分ここで書き換えると怒られる")
//                            user.account.iksmSession = response["iksm_sesson"].string
                        }
                        
                        let summary: JSON = try SplatNet2.getSummary(iksm_session: iksmSession)
                        guard let jobNumRemote: Int = summary["summary"]["card"]["job_num"].int else { return }
                        if jobNumLocal == jobNumRemote { return }
                        
                        #if DEBUG
                        let jobNumRange: Range<Int> = Range(jobNumRemote - 30 ... jobNumRemote)
                        #else
                        let jobNumRange: Range<Int> = Range(max(jobNumRemote - 49, jobNumLocal + 1) ... jobNumRemote)
                        #endif
                        for (idx, jobId) in jobNumRange.enumerated() {
                            let result: JSON = try SplatNet2.getResult(job_id: jobId, iksm_session: iksmSession)
                            #warning("今は毎回書き込んでいるので遅い")
                            try RealmManager.addNewResult(from: result)
                            data.progress += 1 / CGFloat(jobNumRange.count)
                        }
                    }
                    catch {
                        #warning("エラー処理")
                        print(error)
                    }
                    
                }
                
            }
        Button(action: { present.wrappedValue.dismiss() }, label: { Text("BTN_BACK") })
    }
}
