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
                Alert(title: Text(apiError.error), message: Text(apiError.localizedDescription), dismissButton: .default(Text(.BTN_CONFIRM), action: { present.wrappedValue.dismiss() }))
            })
            .navigationTitle(.TITLE_LOGGING_THREAD)
            .preferredColorScheme(.dark)
    }
    
    private func importResultFromSalmonStats() {
        let nsaid: String = manager.playerId
        manager.getAllResults(nsaid: nsaid) { completion in
            switch completion {
            case .success(let results):
                RealmManager.shared.addNewResultsFromSplatNet2(from: results, .salmonstats)
            case .failure(let error):
                apiError = error
                appManager.loggingToCloud(error.localizedDescription)
            }
        }
    }
}

struct ImportingView_Previews: PreviewProvider {
    static var previews: some View {
        ImportingView()
    }
}
