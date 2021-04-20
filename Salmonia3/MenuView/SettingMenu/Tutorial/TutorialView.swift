//
//  TutorialView.swift
//  Salmonia3
//
//  Created by devonly on 2021/04/18.
//

import SwiftUI

struct TutorialView: View {
    @State var selection: Int = 1
    @State var tutorialText: [String] =
    [
        "TAP_MIDDLE_BUTTON",
        "INPUT_TWITTER_ACCOUNT_INFO",
        "WAIT_A_MINUTES",
        "TAP_RIGHT_TOP_BURGER_MENU",
        "TAP_SETTINGS",
        "TAP_GET_API_TOKEN",
        "TAP_COPY_TO_CLIPBOARD",
        "TAP_DONE_LEFT_TOP_BUTTON",
        "TAP_BELOW_BUTTON",
        "CHECK_SALMON_STATS_STATUS"
    ]
    
    var body: some View {
        TabView {
            ForEach(Range(1...10)) { number in
                ZStack {
                    Image("\(number)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .tag(number)
                        .edgesIgnoringSafeArea(.all)
                    Text(tutorialText[number - 1].localized)
                        .splatfont2(.white, size: 20)
                        .padding(.all, 10)
                        .background(Color.river)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
