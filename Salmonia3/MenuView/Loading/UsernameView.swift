//
//  UsernameView.swift
//  Salmonia3
//
//  Created by devonly on 2021/05/13.
//

import SwiftUI
import MBCircleProgressBar
import SplatNet2
import Combine

struct UsernameView: View {
    @Environment(\.presentationMode) var present
    @EnvironmentObject var user: AppSettings
    @AppStorage("apiToken") var apiToken: String?

    @State var isPresented: Bool = false
    @State var apiError: Error?
    @State private var task = Set<AnyCancellable>()
    @State var progressModel = MBCircleProgressModel(progressColor: .red, emptyLineColor: .gray)

    private func dismiss() {
        DispatchQueue.main.async { present.wrappedValue.dismiss() }
    }
    
    var body: some View {
        LoggingThread(progressModel: progressModel)
            .onAppear(perform: getNicknameAndIcons)
            .alert(isPresented: $isPresented) {
                Alert(title: Text("ALERT_ERROR"),
                      message: Text(apiError?.localizedDescription ?? "ERROR"),
                      dismissButton: .default(Text("BTN_DISMISS"), action: { dismiss() }))
            }
    }

    func getNicknameAndIcons() {
        let nsaids: [String] = RealmManager.getNicknames()
        
        log.verbose("GET NICKNAME \(nsaids.count)")
        progressModel.configure(maxValue: CGFloat(nsaids.count))
        
        for nsaid in nsaids.chunked(by: 200) {
            SplatNet2.shared.getNicknameAndIcons(playerId: nsaid)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error)
                    }
                }, receiveValue: { response in
                    progressModel.addValue(value: CGFloat(nsaid.count))
                    RealmManager.updateNicknameAndIcons(players: response)
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
