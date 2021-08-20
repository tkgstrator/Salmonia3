//
//  UsernameView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/05/13.
//

import SwiftUI
import MBCircleProgressBar
import SplatNet2
import Combine

struct UsernameView: View {
    @Environment(\.presentationMode) var present
    @EnvironmentObject var appManager: AppManager
    @AppStorage("apiToken") var apiToken: String?

    @State private var apiError: APIError?
    @State private var task = Set<AnyCancellable>()
    @State private var progressModel = MBCircleProgressModel(progressColor: .red, emptyLineColor: .gray)
    @State private var players: [NicknameIcons.Response.NicknameIcon] = []

    private func dismiss() {
        DispatchQueue.main.async { present.wrappedValue.dismiss() }
    }
    
    var body: some View {
        LoggingThread(progressModel: progressModel)
            .onAppear(perform: getNicknameAndIcons)
            .onDisappear{ RealmManager.shared.updateNicknameAndIcons(players: players) }
            .alert(item: $apiError) { error in
                Alert(title: Text("ALERT_ERROR"),
                      message: Text(error.localizedDescription),
                      dismissButton: .default(Text("BTN_DISMISS"), action: {
//                        appManager.loggingToCloud(error.errorDescription!)
                        present.wrappedValue.dismiss()
                      }))
            }
    }

    func getNicknameAndIcons() {
        let nsaids: [String] = RealmManager.shared.getNicknames()
        progressModel.configure(maxValue: CGFloat(nsaids.count))
        
        for nsaid in nsaids.chunked(by: 200) {
            manager.getNicknameAndIcons(playerId: nsaid)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        apiError = error
                    }
                }, receiveValue: { response in
                    progressModel.addValue(value: CGFloat(nsaid.count))
                    players.append(contentsOf: response.nicknameAndIcons)
                })
                .store(in: &task)
        }
    }
}

struct UsernameView_Previews: PreviewProvider {
    static var previews: some View {
        UsernameView()
    }
}
