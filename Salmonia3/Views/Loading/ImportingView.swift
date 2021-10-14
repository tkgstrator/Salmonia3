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
    @Environment(\.presentationMode) var presentationMode
    @State var task = Set<AnyCancellable>()
    @State var apiError: APIError = .fatalerror
    @State var isPresented: Bool = false
    
    var body: some View {
        LoggingThread()
            .onAppear(perform: importResultFromSalmonStats)
            .alert(isPresented: $isPresented, content: {
                return Alert(title: Text(apiError.error), message: Text(apiError.localizedDescription), dismissButton: .default(Text(.BTN_CONFIRM), action: { presentationMode.wrappedValue.dismiss() }))
            })
            .navigationTitle(.TITLE_LOGGING_THREAD)
    }
    
    private func importResultFromSalmonStats() {
        let nsaid: String = manager.playerId
        manager.getAllResults(nsaid: nsaid) { completion in
            switch completion {
            case .success(let results):
                RealmManager.shared.addNewResultsFromSplatNet2(from: results, .salmonstats)
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                apiError = error
                isPresented.toggle()
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
