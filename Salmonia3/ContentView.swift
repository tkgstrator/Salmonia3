//
//  ContentView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/03/11.
//

import SwiftUI
import SwiftyUI
import SDWebImageSwiftUI

struct ContentView: View {
    @EnvironmentObject var appManager: AppManager
    @State var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection, content: {
            NavigationView {
                CoopResultCollection()
            }
            .tabItem {
                Image(systemName: "gearshape")
                Text(.TITLE_SETTINGS)
            }
            .tag(0)
            StageRecordView()
            .tabItem {
                Image(systemName: "gearshape")
                Text(.TITLE_RECORD)
            }
            .tag(1)
            NavigationView {
                ScheduleView()
            }
            .tabItem {
                Image(systemName: "calendar")
                Text(.TITLE_SHIFT_SCHEDULE)
            }
            .tag(2)
            NavigationView {
                Overview()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "person")
                Text(.TITLE_USER)
            }
            .tag(3)
        })
        .preferredColorScheme(appManager.isDarkMode ? .dark : .light)
        //        .overlay(GoobleMobileAdsView(isAvailable: !appManager.isPaid01, adUnitId: "ca-app-pub-7107468397673752/3033508550"), alignment: .bottom)
        .navigationViewStyle(SplitNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
