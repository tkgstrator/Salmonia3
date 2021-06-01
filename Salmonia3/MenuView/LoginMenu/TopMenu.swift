//
//  TopMenu.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/11.
//

import Foundation
import SwiftUI
import SwiftUIRefresh
import URLImage
import BetterSafariView

struct TopMenu: View {
    @EnvironmentObject var appManager: AppManager
    @EnvironmentObject var main: CoreRealmCoop
    
    @State var isPresented: Bool = false
    @State var isShowing: Bool = false
    @State var isActive: Bool = false
    @State var selectedURL: URL? = nil

    var body: some View {
        ZStack {
            NavigationLink(destination: LoadingView(), isActive: $isActive) { EmptyView() }
            List {
                Section(header: Text(.HEADER_OVERVIEW).splatfont2(.orange, size: 14)) {
                    Overview
                    Results
                    SalmonStats
                }
                Section(header: Text(.HEADER_SCHEDULE).splatfont2(.orange, size: 14)) {
                    ForEach(main.latestShifts, id:\.self) { shift in
                        NavigationLink(destination: CoopShiftStatsView(startTime: shift.startTime), label: {
                            CoopShift(shift: shift)
                        })
                    }
                    NavigationLink(destination: CoopShiftCollection()) {
                        Text(.TITLE_SHIFT_SCHEDULE)
                    }
                }
                Section(header: Text(.HEADER_STAGE_RECORD).splatfont2(.orange, size: 14)) {
                    ForEach(StageType.allCases, id:\.self) { stage in
                        NavigationLink(destination: CoopRecordView(stageId: stage.rawValue)) {
                            Text(stage.name.localized)
                        }
                    }
                }
            }
            .pullToRefresh(isShowing: $isShowing) {
                isActive.toggle()
            }
            .onChange(of: isActive) { _ in
                isShowing = false
            }
        }
        .splatfont2(size: 16)
        .listStyle(GroupedListStyle())
        .navigationTitle(.TITLE_SALMONIA)
    }

    var Overview: some View {
        NavigationLink(destination: SettingView()) {
            HStack {
                URLImage(url: URL(string: appManager.account.thumbnailURL.stringValue)!) { image in image.resizable().clipShape(Circle()) }.frame(width: 70, height: 70)
                Text(appManager.account.nickname.stringValue)
                    .splatfont2(size: 22)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    var Results: some View {
        Group {
            NavigationLink(destination: CoopResultCollection()) {
                Text(.TITLE_RESULT_COLLECTION)
                    .splatfont2(size: 16)
            }
        }
    }
    
    var SalmonStats: some View {
        Button(action: { selectedURL = URL(string: "https://salmon-stats.yuki.games/") }, label: { Text(.TEXT_SALMONSTATS) })
            .safariView(item: $selectedURL) { selectedURL in
                SafariView(
                    url: selectedURL,
                    configuration: SafariView.Configuration(
                        entersReaderIfAvailable: false,
                        barCollapsingEnabled: true
                    )
                )
                .preferredBarAccentColor(.clear)
                .preferredControlAccentColor(.accentColor)
                .dismissButtonStyle(.done)
            }
    }
}
