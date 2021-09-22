//
//  UsernameView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/05/13.
//

import SwiftUI
import SplatNet2
import SwiftyUI
import Combine

struct UsernameView: View {
    @Environment(\.modalIsPresented) var present
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appManager: AppManager
    @State private var isPresented: Bool = false
    @State private var apiError: APIError = .fatalerror
    @State private var players: [NicknameIcons.Response.NicknameIcon] = []

    var body: some View {
        LoggingThread()
            .onAppear(perform: getNicknameAndIcons)
            .alert(isPresented: $isPresented, content: {
                return Alert(title: Text(apiError.error), message: Text(apiError.localizedDescription), dismissButton: .default(Text(.BTN_CONFIRM), action: { present.wrappedValue.dismiss() }))
            })
    }

    private func getNicknameAndIcons() {
        let nsaids: [String] = RealmManager.shared.getNicknames()
        manager.getNicknameAndIcons(playerId: nsaids) { completion in
            switch completion {
            case .success(let response):
                RealmManager.shared.updateNicknameAndIcons(players: response)
                if presentationMode.wrappedValue.isPresented {
                    presentationMode.wrappedValue.dismiss()
                } else {
                    present.wrappedValue.dismiss()
                }
            case .failure(let error):
                apiError = error
                isPresented.toggle()
                appManager.loggingToCloud(error.localizedDescription)
            }
        }
    }
}

struct UsernameView_Previews: PreviewProvider {
    static var previews: some View {
        UsernameView()
    }
}
