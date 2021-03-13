//
//  TopMenu.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/11.
//

import Foundation
import SwiftUI
import SwiftUIRefresh

struct TopMenu: View {
    @EnvironmentObject var main: CoreAppSetting
    @State var isShowing: Bool = false
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            NavigationLink(destination: LoadingView(), isActive: $isActive) { EmptyView() }
            List {
                Section(header: Text("HEADER_OVERVIEW")) {
                    Text("TEXT_WELCOME")
                }
                Section(header: Text("HEADER_SCHEDULE")) {
                    Text("TEXT_WELCOME")
                }
                Section(header: Text("HEADER_RECORD")) {
                    Text("TEXT_WELCOME")
                }
            }
            .pullToRefresh(isShowing: $isShowing) {
                isActive.toggle()
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle("TITLE_SALMONIA")
//        .listStyle(SidebarListStyle())
//        VStack {
//
//            Text("TEXT_WELCOME")
//            Button(action: { AppManager.isLogin(isLogin: false) }, label: { Text("BTN_LOGOUT") })
//        }
    }
    
//    var Overview: some View {
//
//    }
}
