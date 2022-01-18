//
//  ContentView.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/19.
//

import SwiftUI
import SwiftyUI

struct ContentView: View {
    @EnvironmentObject var service: AppManager
    @State var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection, content: {
            ResultCollectionView()
                .tabItem({
                    Image(systemName: .House)
                    Text("TAB.HOME", comment: "リザルト一覧")
                })
                .tag(0)
            ShiftCollectionView()
                .tabItem({
                    Image(systemName: .ListBulletRectangle)
                    Text("TAB.SHIFT", comment: "シフト一覧")
                })
                .tag(1)
            UserView()
                .tabItem({
                    Image(systemName: .Person)
                    Text("TAB.USER", comment: "ユーザ")
                })
                .tag(2)
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
