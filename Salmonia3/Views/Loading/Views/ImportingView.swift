//
//  ImportingView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/04/18.
//

import SwiftUI
import Combine
import SalmonStats
import SplatNet2

struct ImportingView: View {
    @EnvironmentObject var appManager: AppManager
    @Environment(\.presentationMode) var present
    @State var task = Set<AnyCancellable>()
    @State var apiError: APIError? = nil
    
    var body: some View {
        LoggingThread()
            .onAppear(perform: importResultFromSalmonStats)
            .alert(item: $apiError, content: { apiError in
                Alert(title: "ERROR".localized, message: apiError.localizedDescription)
            })
            .navigationTitle(.TITLE_LOGGING_THREAD)
    }
    
    private func importResultFromSalmonStats() {
        manager.getAllResults(nsaid: manager.playerId) { completion in
            switch completion {
            case .success(let results):
                RealmManager.shared.addNewResultsFromSplatNet2(from: results, .salmonstats)
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct ImportingView_Previews: PreviewProvider {
    static var previews: some View {
        ImportingView()
    }
}
