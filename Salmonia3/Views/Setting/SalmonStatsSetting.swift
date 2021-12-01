//
//  SalmonStatsSetting.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/01.
//

import SwiftUI

struct SalmonStatsSetting: View {
    @EnvironmentObject var appManager: AppManager
    @State var isPresented: Bool = false
    
    var body: some View {
        Form(content: {
            Section(content: {
                HStack(content: {
                    Text("Credential")
                    Spacer()
                    Text(appManager.apiToken?.prefix(16) ?? "-")
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                })
            }, header: {
                Text("Salmon Stats")
            })
            Section(content: {
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    Text("Sign in")
                })
                    .authorizeToken(isPresented: $isPresented, manager: appManager, completion: { result in
                    })
            }, header: {
                Text("Service")
            })
        })
            .navigationTitle("Salmon Stats")
    }
}

struct SalmonStatsSetting_Previews: PreviewProvider {
    static var previews: some View {
        SalmonStatsSetting()
    }
}
