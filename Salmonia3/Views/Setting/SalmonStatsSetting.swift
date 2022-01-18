//
//  SalmonStatsSetting.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/01.
//

import SwiftUI

struct SalmonStatsSetting: View {
    @EnvironmentObject var service: AppManager
    @State var isPresented: Bool = false
    
    var body: some View {
        Form(content: {
            Section(content: {
                HStack(content: {
                    Text("STATS.CREDENTIAL", comment: "APIトークン")
                    Spacer()
                    Text(service.connection.apiToken?.prefix(16) ?? "-")
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                })
            }, header: {
                Text("HEADER.SALMON.STATS", comment: "SalmonStats")
            })
            Section(content: {
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    Text("STATS.SIGNIN", comment: "SalmonStatsと連携")
                })
                    .authorizeToken(isPresented: $isPresented, manager: service.connection, completion: { result in
                    })
            }, header: {
                Text("HEADER.SERVICE", comment: "サービスヘッダー")
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
