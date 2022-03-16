//
//  ContentView.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/19.
//

import SwiftUI
import SwiftyUI
import SplatNet2

struct ContentView: View {
    @EnvironmentObject var service: AppService
    @State var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection, content: {
            ResultCollectionView()
                .tabItem({
                    Image(systemName: .House)
                    Text("リザルト一覧")
                })
                .tag(0)
            WaveCollectionView()
                .tabItem({
                    Image(systemName: .ListBulletRectangle)
                    Text("WAVE一覧")
                })
                .tag(1)
            ShiftCollectionView()
                .tabItem({
                    Image(systemName: .ListBulletRectangle)
                    Text("シフト一覧")
                })
                .tag(2)
            UserView()
                .tabItem({
                    Image(systemName: .Person)
                    Text("ユーザ")
                })
                .tag(3)
        })
        .font(systemName: service.apperances.fontStyle, size: 16)
        .preferredColorScheme(service.apperances.colorScheme)
        .fullScreenCover(isPresented: $service.isSignIn, onDismiss: {}, content: {
            CircleProgressView(state: service.signInState)
        })
        .fullScreenCover(isPresented: $service.isLoading, onDismiss: { service.isLoading = false }, content: {
            LoadingView()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
