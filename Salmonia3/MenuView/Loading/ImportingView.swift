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
    @State var task = Set<AnyCancellable>()
    
    private func dismiss() {
        DispatchQueue.main.async { present.wrappedValue.dismiss() }
    }
    
    var body: some View {
        LoggingThread(data: $data)
            .onAppear {
                let nsaid = "91d160aa84e88da6"
                SalmonStats.shared.getMetadata(nsaid: nsaid)
                    .sink(receiveCompletion: { completion in
                    }, receiveValue: { metadata in
                        for userdata in metadata {
                            let lastPageId: Int = Int((userdata.results.clear + userdata.results.fail) / 200) + 1
                            for pageId in Range(1 ... 1) {
                                SalmonStats.shared.getResults(nsaid: userdata.playerId, pageId: pageId)
                                    .sink(receiveCompletion: { completion in
                                        switch completion {
                                        case .finished:
                                            print("FINISHED")
                                        case .failure(let error):
                                            print(error)
                                        }
                                    }, receiveValue: { results in
                                        RealmManager.addNewResultsFromSalmonStats(from: results, pid: nsaid)
                                    })
                                    .store(in: &task)
                            }
                        }
                    })
                    .store(in: &task)
            }
            .navigationTitle("TITLE_IMPORT_SALMONSTATS")
    }
}

struct ImportingView_Previews: PreviewProvider {
    static var previews: some View {
        ImportingView()
    }
}
