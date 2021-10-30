//
//  ContentView.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/19.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appManager: AppManager
    @State var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection, content: {
            ResultCollectionView()
                .tabItem({
                    Image(.home)
                })
                .tag(0)
            SplatNet2LoginView()
                .tabItem({
                    Image(.home)
                })
                .tag(1)
            SalmonStatsLoginView()
                .tabItem({
                    Image(.home)
                })
                .tag(2)
            SettingView()
                .tabItem({
                    Image(.setting)
                })
                .tag(3)
        })
            .font(appManager.apperances.fontStyle, size: 16)
            .preferredColorScheme(appManager.apperances.colorScheme)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
