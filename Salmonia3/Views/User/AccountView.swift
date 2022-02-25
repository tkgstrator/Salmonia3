//
//  AccountView.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/12.
//

import SwiftUI
import SwiftyUI

struct AccountView: View {
    @EnvironmentObject var service: AppService
    @State var isPresented: Bool = false
    
    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            HStack(content: {
                Text("アカウント")
                Spacer()
                Text(service.session.account?.nickname ?? "未ログイン")
                    .foregroundColor(.secondary)
            })
        })
            .halfsheet(
                isPresented: $isPresented,
                transitionStyle: .coverVertical,
                presentationStyle: .automatic,
                isModalInPresentation: false,
                detentIdentifier: .medium,
                prefersScrollingExpandsWhenScrolledToEdge: true,
                prefersEdgeAttachedInCompactHeight: true,
                detents: .medium,
                widthFollowsPreferredContentSizeWhenEdgeAttached: true,
                prefersGrabberVisible: true,
                onDismiss: {},
                content: {
                    Picker(selection: $service.session.account, content: {
                        ForEach(service.session.accounts) { account in
                            Text(account.nickname)
                                .tag(Optional(account))
                        }
                    }, label: {})
                        .pickerStyle(.wheel)
                })
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
