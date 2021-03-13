//
//  TopMenu.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/11.
//

import Foundation
import URLImage
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
                    Overview
                    Text("TEXT_WELCOME")
                    Button(action: { AppManager.isLogin(isLogin: false) }, label: { Text("BTN_LOGOUT") })
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
    
    var Overview: some View {
        NavigationLink(destination: LoadingView()) {
            HStack {
                URLImage(url: URL(string: main.account.thumbnailURL.stringValue)!) { image in image.resizable().clipShape(Circle()) }.frame(width: 70, height: 70)
                Text(main.account.nickname.stringValue)
                    .splatfont2(size: 22)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    var Results: some View {
        Group {
            NavigationLink(destination: CoopResultCollection()) {
                Text("TITLE_JOB_RESULTS")
                    .splatfont2(size: 16)
            }
            //            NavigationLink(destination: WaveCollectionView()) {
            //                Text("TITLE_WAVE_RESULTS")
            //                    .splatfont2(size: 16)
            //            }
        }
    }
}
