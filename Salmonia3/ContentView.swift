//
//  ContentView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/03/11.
//

import SwiftUI
import SwiftUIX
import SwiftyUI
import SDWebImageSwiftUI
import Introspect
import BetterSafariView

struct ContentView: View {
    @EnvironmentObject var appManager: AppManager
    @State var selection: Int = 0
    
    struct CollectionView: View {
        @State var collectionType: Bool = true
        
        var toggleButton: some View {
            Button(action: {
                collectionType.toggle()
            }, label: {
                Image(systemName: "switch.2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            })
        }
        
        var body: some View {
            NavigationView {
                switch collectionType {
                case true:
                    CoopResultCollection()
                        .navigationBarItems(trailing: toggleButton)
                case false:
                    CoopWaveCollection()
                        .navigationBarItems(trailing: toggleButton)
                }
            }
            .navigationViewStyle(SplitNavigationViewStyle())
        }
    }
    
    var googleMobileAds: some View {
        GoobleMobileAdsView(isAvailable: !appManager.isPaid01, adUnitId: "ca-app-pub-7107468397673752/3033508550")
    }
    
    var body: some View {
        TabView(selection: $selection, content: {
            CollectionView()
                .navigationViewStyle(SplitNavigationViewStyle())
                .tabItem {
                    Image(systemName: "network")
                    Text(.TITLE_COLLECTION)
                }
                .overlay(googleMobileAds, alignment: .bottom)
                .tag(0)
            StageRecordView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text(.TITLE_RECORD)
                }
                .overlay(googleMobileAds, alignment: .bottom)
                .tag(1)
            NavigationView {
                ScheduleView()
            }
            .tabItem {
                Image(systemName: "calendar")
                Text(.TITLE_SHIFT_SCHEDULE)
            }
            .overlay(googleMobileAds, alignment: .bottom)
            .tag(2)
            if appManager.isFree04 {
                SafariView(
                    url: URL(string: "https://salmon-stats.yuki.games/players/\(manager.playerId)")!,
                    configuration: SafariView.Configuration(
                        entersReaderIfAvailable: false,
                        barCollapsingEnabled: true
                    )
                )
                .preferredBarAccentColor(.clear)
                .preferredControlAccentColor(.accentColor)
                .dismissButtonStyle(.done)
                .tabItem {
                    Image(systemName: "safari")
                    Text(.TITLE_SALMONSTATS)
                }
                .overlay(googleMobileAds, alignment: .bottom)
                .tag(3)
            }
            NavigationView {
                Overview()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "person")
                Text(.TITLE_USER)
            }
            .overlay(googleMobileAds, alignment: .bottom)
            .tag(4)
        })
        .preferredColorScheme(appManager.isDarkMode ? .dark : .light)
        .navigationViewStyle(SplitNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
