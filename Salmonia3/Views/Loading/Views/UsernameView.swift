//
//  UsernameView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/05/13.
//

import SwiftUI
import SplatNet2
import Combine

struct UsernameView: View {
    @Environment(\.presentationMode) var present
    @EnvironmentObject var appManager: AppManager
    
    @State private var apiError: APIError?
    @State private var task = Set<AnyCancellable>()
    @State private var players: [NicknameIcons.Response.NicknameIcon] = []


    var body: some View {
        LoggingThread()
            .onAppear(perform: getNicknameAndIcons)
    }

    func getNicknameAndIcons() {
        let nsaids: [String] = RealmManager.shared.getNicknames()
        manager.getNicknameAndIcons(playerId: nsaids) { completion in
            switch completion {
            case .success(let response):
                RealmManager.shared.updateNicknameAndIcons(players: response)
            case .failure(let error):
                apiError = error
            }
        }
    }
}

struct UsernameView_Previews: PreviewProvider {
    static var previews: some View {
        UsernameView()
    }
}
