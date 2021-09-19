//
//  TutorialView.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/19.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI
import VideoPlayer

struct TutorialView: View {
    @State var isPresented: Bool = false
    @State var isShowing: Bool = false
    @State var isPlaying: Bool = true
    private let url = Bundle.main.url(forResource: "tutorial", withExtension: "mp4")!
    
    var body: some View {
        Button(action: {
            isShowing.toggle()
        }, label: {
            Image(systemName: "questionmark.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .imageScale(.large)
                .foregroundColor(.white)
        })
        .alert(isPresented: $isShowing, content: {
            Alert(title: Text(.TEXT_TUTORIAL), message: Text(.TEXT_TUTORIAL), primaryButton: .default(Text(.PLAY_VIDEO), action: {
                isPresented.toggle()
            }),
            secondaryButton: .destructive(Text(.BTN_CANCEL)))
        })
        .sheet(isPresented: $isPresented, content: {
            VideoPlayer(url: url, play: $isPlaying)
        })
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
