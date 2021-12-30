//
//  SalmonStatPlusSetting.swift
//  Salmonia3
//
//  Created by devonly on 2021/11/24.
//  
//

import SwiftUI
import Combine

struct SalmonStatPlusSetting: View {
    @EnvironmentObject var service: AppManager
    @State var task = Set<AnyCancellable>()
    
    var body: some View {
        Form(content: {
            Section(content: {
                HStack(content: {
                    Text("Username")
                    Spacer()
                    Text(service.user?.displayName ?? "-")
                        .foregroundColor(.secondary)
                })
                HStack(content: {
                    Text("ProviderID")
                    Spacer()
                    Text(service.user?.providerID ?? "-")
                        .foregroundColor(.secondary)
                })
            }, header: {
                Text("User")
            })
            Section(content: {
                Button(action: {
                    service.twitterSignin()
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
            .navigationTitle("SalmonStats+")
    }
}

struct SalmonStatPlusSetting_Previews: PreviewProvider {
    static var previews: some View {
        SalmonStatPlusSetting()
    }
}
