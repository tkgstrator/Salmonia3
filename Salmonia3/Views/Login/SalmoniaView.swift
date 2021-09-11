//
//  TopMenu.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/03/11.
//

import Foundation
import SwiftUI
import SwiftUIRefresh
import URLImage
import BetterSafariView

struct SalmoniaView: View {
    @EnvironmentObject var appManager: AppManager
    @EnvironmentObject var main: CoreRealmCoop
    @State var isPresented: Bool = false
    @State var isShowing: Bool = false
    @State var isActive: Bool = false
    @State var selectedURL: URL? = nil

    var body: some View {
        List {
            Section(header: Text(.HEADER_OVERVIEW).splatfont2(.safetyorange, size: 14)) {
                Overview
                Results
                Waves
                Players
                SalmonStats
            }
            Section(header: Text(.HEADER_SCHEDULE).splatfont2(.safetyorange, size: 14)) {
                ForEach(main.latestShift, id:\.self) { shift in
                    NavigationLink(
                        destination: CoopShiftStatsView(startTime: shift.startTime)
                            .environmentObject(CoopShiftStats(startTime: shift.startTime)),
                        label: {
                            CoopShift(shift: shift)
                        })
                }
                NavigationLink(destination: CoopShiftCollection(displayFutureShift: appManager.isFree02)) {
                    Text(.TITLE_SHIFT_SCHEDULE)
                }
            }
            Section(header: Text(.HEADER_STAGE_RECORD).splatfont2(.safetyorange, size: 14)) {
                ForEach(StageType.allCases, id:\.self) { stage in
                    NavigationLink(destination: CoopRecordView(stageId: stage.rawValue)) {
                        Text(stage.localizedName)
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .overlay(NavigationLink(destination: LoadingView(), isActive: $isActive) { EmptyView() })
        .pullToRefresh(isShowing: $isShowing, onRefresh: {
            isActive.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                isShowing.toggle()
            })
        })
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
        .splatfont2(size: 16)
        .navigationBarBackButtonHidden(true)
        .navigationTitle(.TITLE_SALMONIA)
    }
    
    var Overview: some View {
        NavigationLink(destination: SettingView()) {
            HStack {
                URLImage(url: manager.account.imageUri) { image in image.resizable().clipShape(Circle()) }.frame(width: 70, height: 70)
                Text(manager.account.nickname)
                    .splatfont2(size: 22)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    var Results: some View {
        NavigationLink(destination: CoopResultCollection()) {
            Text(.TITLE_RESULT_COLLECTION)
                .splatfont2(size: 16)
        }
    }
    
    var Waves: some View {
        NavigationLink(destination: CoopWaveCollection()) {
            Text(.TITLE_WAVE_COLLECTION)
                .splatfont2(size: 16)
        }
    }
    
    var Players: some View {
        NavigationLink(destination: CoopPlayerCollection()) {
            Text(.TITLE_PLAYER_COLLECTION)
                .splatfont2(size: 16)
        }
    }
    
    var SalmonStats: some View {
        Button(action: {
            if let _ = manager.apiToken {
                selectedURL = URL(string: "https://salmon-stats.yuki.games/players/\(manager.playerId)")
            } else {
                selectedURL = URL(string: "https://salmon-stats-api.yuki.games/auth/twitter")
            }
        }, label: { Text(.SALMON_STATS) })
    }
    
    var SalmonRecords: some View {
        Button(action: { selectedURL = URL(string: "https://gungeespla.github.io/salmon_run_records/") }, label: { Text(.SALMON_RUN_RECORDS) })
    }
    
    var LanPlayRecords: some View {
        Button(action: { selectedURL = URL(string: "https://salmonrun-records.netlify.app/") }, label: { Text(.LANPLAY_RECORDS) })
    }
}
