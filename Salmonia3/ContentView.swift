//
//  ContentView.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/11.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appManager: AppManager
    
    var body: some View {
        NavigationView {
            TopMenu()
            SettingView()
        }
        .overlay(!appManager.isPaid02 ? AnyView(GoobleMobileAdsView()) : AnyView(EmptyView()), alignment: .bottom)
        .navigationViewStyle(SplitNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
