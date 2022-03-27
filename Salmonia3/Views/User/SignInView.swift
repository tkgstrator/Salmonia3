//
//  SignInView.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/12.
//

import SwiftUI
import SplatNet2
import SalmonStats

struct SignInView: View {
    @StateObject var service: LoginService = LoginService()
    @State var isPresented: Bool = false
    
    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Text("ログインする")
        })
            .authorize(isPresented: $isPresented, session: service.session)
            .fullScreenCover(isPresented: $service.isPresented, content: {
                LoginView(service: service)
            })
    }
}

struct SignInStatsView: View {
    @EnvironmentObject var service: AppService
    @State var isPresented: Bool = false
    
    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            HStack(content: {
                Text("連携する")
                Spacer()
                Text(service.session.apiToken == nil ? "未連携" : "連携済み")
                    .foregroundColor(.secondary)
            })
        })
            .authorizeToken(isPresented: $isPresented, session: service.session)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}


