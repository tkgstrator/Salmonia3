//
//  ContentView.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/11.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var main: CoreAppSetting

    var body: some View {
        switch main.isLogin {
        case false:
            NavigationView {
                LoginMenu()
            }
            .navigationViewStyle(StackNavigationViewStyle())
        case true:
            NavigationView {
                TopMenu()
            }
            .listStyle(GroupedListStyle())
            .navigationViewStyle(LegacyNavigationViewStyle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
