//
//  LaunchScreen.swift
//  Salmonia3
//
//  Created by devonly on 2021/08/26.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftyAPNGKit

struct LaunchScreenView: View {
    @Environment(\.scenePhase) var scene
    @State var isVisible: Bool = true
    
    var body: some View {
        ZStack {
            ContentView()
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                APNGView(named: "LoadingIka")
                    .frame(width: 64, height: 64)
            }
            .opacity(isVisible ? 1.0 : 0.0)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    withAnimation {
                        self.isVisible.toggle()
                    }
                })
            }
            .onChange(of: scene) { phase in
                switch phase {
                case .active:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        withAnimation {
                            isVisible.toggle()
                        }
                    })
                case .background:
                    withAnimation {
                        isVisible.toggle()
                    }
                case .inactive:
                    break
                @unknown default:
                    break
                }
            }
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
