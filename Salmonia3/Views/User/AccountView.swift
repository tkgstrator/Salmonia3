//
//  AccountView.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/12.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftyUI
import Common

struct AccountView: View {
    @EnvironmentObject var service: LoadingService
    @State var isPresented: Bool = false

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Image(systemName: .ArrowTriangle2Circlepath)
                .font(Font.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
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
                AccountPickerView()
                    .environmentObject(service)
            })
    }
}

struct AccountPickerView: View {
    @EnvironmentObject var service: LoadingService
    @State var account: UserInfo?

    var body: some View {
        Picker(selection: $service.account, content: {
            let accounts = service.session.accounts.sorted(by: { $0.credential.nsaid < $1.credential.nsaid })
            ForEach(accounts, id:\.self) { account in
                Text(account.nickname)
                    .tag(account as? UserInfo)
            }
        }, label: {
        })
        .pickerStyle(.wheel)
        .onChange(of: service.account, perform: { value in
            service.session.account = value
            service.objectWillChange.send()
        })
    }
}


struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
