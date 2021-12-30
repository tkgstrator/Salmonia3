//
//  ContentView.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/19.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var service: AppManager
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
            UserView()
                .tabItem({
                    Image(.setting)
                })
                .tag(3)
        })
            .font(systemName: service.apperances.fontStyle, size: 16)
            .preferredColorScheme(service.apperances.colorScheme)
            .fullScreenCover(isPresented: $service.isLoading, onDismiss: { service.isLoading = false }, content: {
                LoadingView()
                    .environmentObject(service)
                    .font(systemName: service.apperances.fontStyle, size: 16)
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
