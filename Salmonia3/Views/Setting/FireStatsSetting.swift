//
//  FireStatsSetting.swift
//  Salmonia3
//
//  Created by devonly on 2021/11/24.
//  
//

import SwiftUI
import Combine

struct FireStatsSetting: View {
    @EnvironmentObject var appManager: AppManager
    @State var task = Set<AnyCancellable>()
    
    var body: some View {
        Form(content: {
            Section(content: {
                HStack(content: {
                    Text("Username")
                    Spacer()
                    Text(appManager.user?.displayName ?? "-")
                        .foregroundColor(.secondary)
                })
                HStack(content: {
                    Text("ProviderID")
                    Spacer()
                    Text(appManager.user?.providerID ?? "-")
                        .foregroundColor(.secondary)
                })
            }, header: {
                Text("User")
            })
            Section(content: {
                Button(action: {
                    appManager.twitterSignin()
                        .sink(receiveCompletion: { _ in
                        }, receiveValue: { _ in
                        })
                        .store(in: &task)
                }, label: {
                    Text("Twitter")
                })
            }, header: {
                Text("Service")
            })
        })
            .navigationTitle("FireStats")
    }
}

struct FireStatsSetting_Previews: PreviewProvider {
    static var previews: some View {
        FireStatsSetting()
    }
}
