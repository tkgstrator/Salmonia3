//
//  SalmonLoginMenu.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/11.
//

import Foundation
import SwiftUI

struct SalmonLoginMenu: View {
    @State var isActive: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 30) {
                Text("TEXT_WELCOME")
//                Spacer()
                Button(action: { isActive.toggle() }, label: { Text("BTN_SIGN_IN") })
                    .buttonStyle()
                Button(action: {}, label: { Text("BTN_SIGN_UP") })
                    .buttonStyle()
            }
            .position(x: geometry.frame(in: .local).midX, y: geometry.size.height / 4)
        }
        .background(BackGround)
        .navigationTitle("TITLE_LOGIN")
    }
    
    var BackGround: some View {
        Group {
            LinearGradient(gradient: Gradient(colors: [.blue, .river]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
//            NavigationLink(destination: TopMenu(), isActive: $isActive) { EmptyView() }
        }
    }
}
