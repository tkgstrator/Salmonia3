//
//  AddAccountButton.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/19.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftUIX

struct AddAccountButton: View {
    @EnvironmentObject var appManager: AppManager
    @State var isPresented: Bool = false

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Image(systemName: "plus.circle")
                .resizable()
                .imageScale(.large)
                .foregroundColor(.blue)
                .visible(appManager.isPaid02)
        })
        .buttonStyle(DefaultButtonStyle())
        .alert(isPresented: $isPresented, content: {
            Alert(title: Text("アカウント追加"), message: Text("アカウントを追加します"), primaryButton: .default(Text(.BTN_CONFIRM), action: {
                appManager.isSignedIn.toggle()
            }), secondaryButton: .cancel())
        })
    }
}

struct AddAccountButton_Previews: PreviewProvider {
    static var previews: some View {
        AddAccountButton()
    }
}
