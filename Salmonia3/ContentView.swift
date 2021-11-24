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
            ShiftCollectionView()
                .tabItem({
                    Image(.home)
                })
                .tag(1)
            SettingView()
                .tabItem({
                    Image(.setting)
                })
                .tag(2)
        })
            .font(systemName: appManager.apperances.fontStyle, size: 16)
            .preferredColorScheme(appManager.apperances.colorScheme)
            .fullScreenCover(isPresented: $appManager.isLoading, onDismiss: { appManager.isLoading = false }, content: {
                LoadingView()
                    .environmentObject(appManager)
                    .font(systemName: appManager.apperances.fontStyle, size: 16)
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
