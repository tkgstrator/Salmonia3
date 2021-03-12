//
//  ContentView.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/11.
//

import SwiftUI

struct ContentView: View {
    @State var isLogin: Bool = false
    
    var body: some View {
        switch !isLogin {
        case true:
            NavigationView {
                LoginMenu()
            }
            .navigationViewStyle(StackNavigationViewStyle())
        case false:
            NavigationView {
                TopMenu()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
