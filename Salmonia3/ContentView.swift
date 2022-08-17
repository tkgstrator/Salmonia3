//
//  ContentView.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/19.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftyUI
import SplatNet2

struct ContentView: View {
    @EnvironmentObject var service: AppService
    @State var selection: Int = 3
    @AppStorage("work.tkgstrator.disableads") var isAdsDisalbed: Bool = false

    var body: some View {
        TabView(selection: $selection, content: {
            ResultCollectionView()
                .withAdmobBanner(isAdDisabled: isAdsDisalbed)
                .tabItem({
                    Image(systemName: .House)
                    Text("リザルト一覧")
                })
                .tag(0)
            WaveCollectionView()
                .withAdmobBanner(isAdDisabled: isAdsDisalbed)
                .tabItem({
                    Image(systemName: .ListBulletRectangle)
                    Text("WAVE一覧")
                })
                .tag(1)
            ShiftCollectionView()
                .withAdmobBanner(isAdDisabled: isAdsDisalbed)
                .tabItem({
                    Image(systemName: .ListBulletRectangle)
                    Text("シフト一覧")
                })
                .tag(2)
            UserView()
                .withAdmobBanner(isAdDisabled: isAdsDisalbed)
                .tabItem({
                    Image(systemName: .Person)
                    Text("ユーザ")
                })
                .tag(3)
        })
        .preferredColorScheme(service.apperances.colorScheme)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
