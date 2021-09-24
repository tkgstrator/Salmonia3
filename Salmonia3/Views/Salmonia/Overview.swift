//
//  Overview.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/21.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftyUI
import SDWebImageSwiftUI

struct Overview: View {
    @EnvironmentObject var appManager: AppManager
    @EnvironmentObject var results: CoreRealmCoop
    @State var isPresented: Bool = false
    @State var isShowing: Bool = false

    var waveClearChart: some View {
        HStack(alignment: .center, spacing: nil, content: {
            VStack(alignment: .center, spacing: nil, content: {
                ForEach(results.clearResults.waves) { wave in
                    HStack(alignment: .center, spacing: nil, content: {
                        Text("FAILURE_WAVE_\(results.clearResults.waves.firstIndex(of: wave)! + 1)")
                        Spacer()
                        Text(String(format: "%.2f%%", 100 * Double(wave.failure.timeLimit + wave.failure.wipeOut) / Double(results.clearResults.total)))
                    })
                    .frame(maxWidth: 200)
                    .padding(.trailing)
                }
                HStack(alignment: .center, spacing: nil, content: {
                    Text(.CLEAR_WAVE)
                    Spacer()
                    Text(String(format: "%.2f%%", 100 * Double(results.clearResults.clear) / Double(results.clearResults.total)))
                })
                .frame(maxWidth: 200)
                .padding(.trailing)
            })
            .font(.custom("Splatfont2", size: 16))
            Spacer()
            PieChartView(results.clearResults.waves.map({ $0.failure.timeLimit + $0.failure.wipeOut }) + [results.clearResults.clear], caption: "バイト回数")
        })
        .padding()
    }
    
    var failureReasonChart: some View {
        HStack(alignment: .center, spacing: nil, content: {
            VStack(alignment: .center, spacing: nil, content: {
                HStack(alignment: .center, spacing: nil, content: {
                    Text(.FAILURE_TIME_LIMIT)
                    Spacer()
                    Text(String(format: "%.2f%%", 100 * Double(results.clearResults.failure.timeLimit) / Double(results.clearResults.total - results.clearResults.clear)))
                })
                .padding(.trailing)
                HStack(alignment: .center, spacing: nil, content: {
                    Text(.FAILURE_WIPE_OUT)
                    Spacer()
                    Text(String(format: "%.2f%%", 100 * Double(results.clearResults.failure.wipeOut) / Double(results.clearResults.total - results.clearResults.clear)))
                })
                .padding(.trailing)
            })
            .font(.custom("Splatfont2", size: 16))
            Spacer()
            PieChartView([results.clearResults.failure.timeLimit, results.clearResults.failure.wipeOut], caption: "失敗回数")
        })
        .padding()
    }
    
    var playerOverview: some View {
        VStack(alignment: .center, spacing: nil, content: {
            HStack(alignment: .center, spacing: nil, content: {
                WebImage(url: manager.account.imageUri)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                Text(manager.account.nickname)
                    .frame(maxWidth: .infinity)
                    .font(.custom("Splatfont2", size: 28))
            })
            HStack(alignment: .center, spacing: nil, content: {
                VStack(alignment: .center, spacing: nil, content: {
                    Text(.RESULT_JOB_NUM)
                    Text("\(manager.account.coop.jobNum)")
                })
                .padding()
                .font(.custom("Splatfont2", size: 16))
                .foregroundColor(.red)
                VStack(alignment: .center, spacing: nil, content: {
                    Text(.RESULT_POWER_EGGS)
                    Text("\(manager.account.coop.ikuraTotal)")
                })
                .padding()
                .font(.custom("Splatfont2", size: 16))
                .foregroundColor(.red)
                VStack(alignment: .center, spacing: nil, content: {
                    Text(.RESULT_GOLDEN_EGGS)
                    Text("\(manager.account.coop.goldenIkuraTotal)")
                })
                .padding()
                .font(.custom("Splatfont2", size: 16))
                .foregroundColor(.yellow)
            })
        })
        .padding()
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            Section(header: Text(.HEADER_OVERVIEW).font(.custom("Splatfont2", size: 16)), content: {
                playerOverview
            })
            Divider()
            Section(header: Text(.HEADER_FAILURE_WAVE).font(.custom("Splatfont2", size: 16)), content: {
                waveClearChart
            })
            Divider()
            Section(header: Text(.HEADER_FAILURE_REASON).font(.custom("Splatfont2", size: 16)), content: {
                failureReasonChart
            })
        })
        .navigationBarItems(trailing: NavigationLink(destination: SettingView().navigationViewStyle(SplitNavigationViewStyle()), label: {
            Image(systemName: "gearshape")
        }))
        .onAppear {
            print(dump(results.clearResults))
        }
//        .overlay(NavigationLink(destination: LoadingView(), isActive: $isShowing, label: { EmptyView() }))
        .pullToRefresh(isShowing: $isShowing, onRefresh: {
            isPresented.toggle()
            isShowing.toggle()
        })
        .present(isPresented: $isPresented, transitionStyle: .flipHorizontal, presentationStyle: .fullScreen, content: {
            LoadingView()
                .environmentObject(appManager)
                .environment(\.modalIsPresented, .constant(PresentationStyle($isPresented)))
        })
        .navigationTitle(.TITLE_USER)
    }
}

struct Overview_Previews: PreviewProvider {
    static var previews: some View {
        Overview()
            .environmentObject(AppManager())
            .environmentObject(CoreRealmCoop())
    }
}
