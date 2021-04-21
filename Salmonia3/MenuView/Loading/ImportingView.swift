//
//  ImportingView.swift
//  Salmonia3
//
//  Created by devonly on 2021/04/18.
//

import SwiftUI
import Combine
import SalmonStats

struct ImportingView: View {
    @Environment(\.presentationMode) var present
    @State var data: ProgressData = ProgressData()
    @State var task: AnyCancellable?
    
    private func dismiss() {
        DispatchQueue.main.async { present.wrappedValue.dismiss() }
    }
    
    var body: some View {
        LoggingThread(data: $data)
            .onAppear {
                task = SalmonStats.shared.getMetadata(nsaid: "91d160aa84e88da6")
                    .sink(receiveCompletion: { completion in
                    }, receiveValue: { metadata in
                        for userdata in metadata {
                            let lastPageId: Int = Int((userdata.results.clear + userdata.results.fail) / 200) + 1
                            print("LastPageID", lastPageId)
                            for pageId in Range(1 ... 1) {
                                task = SalmonStats.shared.getResults(nsaid: userdata.playerId, pageId: pageId)
                                    .sink(receiveCompletion: { completion in
                                        switch completion {
                                        case .finished:
                                            print("FINISHED")
                                        case .failure(let error):
                                            print(error)
                                        }
                                    }, receiveValue: { results in
                                        RealmManager.addNewResultsFromSalmonStats(from: results)
                                    })
                            }
                        }
                    })
//                task = SalmonStats.shared.getResults(nsaid: <#T##String#>, pageId: <#T##Int#>)
            }
            .navigationTitle("TITLE_IMPORT_SALMONSTATS")
    }
}

struct ImportingView_Previews: PreviewProvider {
    static var previews: some View {
        ImportingView()
    }
}
