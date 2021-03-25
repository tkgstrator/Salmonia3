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
    @EnvironmentObject var main: AppSettings
    @State var isShowing: Bool = false
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            NavigationLink(destination: LoadingView(), isActive: $isActive) { EmptyView() }
            List {
                Section(header: Text("HEADER_OVERVIEW").splatfont2(.orange, size: 14)) {
                    Overview
                    Results
                }
                Section(header: Text("HEADER_SCHEDULE").splatfont2(.orange, size: 14)) {
                    NavigationLink(destination: CoopShiftCollection()) {
                        Text("LINK_COOP_SCHEDULE")
                    }
                }
            }
            .pullToRefresh(isShowing: $isShowing) {
                isActive.toggle()
                isShowing.toggle()
            }
        }
        .splatfont2(size: 16)
        .listStyle(GroupedListStyle())
        .navigationTitle("TITLE_SALMONIA")
    }
    
    var Overview: some View {
        NavigationLink(destination: SettingView()) {
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
                Text("LINK_RESULTS")
                    .splatfont2(size: 16)
            }
            //            NavigationLink(destination: WaveCollectionView()) {
            //                Text("TITLE_WAVE_RESULTS")
            //                    .splatfont2(size: 16)
            //            }
        }
    }
}
