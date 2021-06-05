//
//  HelpView.swift
//  Salmonia3
//
//  Created by devonly on 2021/06/06.
//

import SwiftUI
import BetterSafariView

struct HelpView: View {
    @State var url: URL?
    
    var body: some View {
        List {
            Button(action: { url = URL(string: "https://github.com/tkgstrator/Salmonia3/raw/develop/Resources/06.png") }, label: { Text(.HELP_GET_RESULT).font(.custom("Splatfont2", size: 16)) })
            Button(action: { url = URL(string: "https://github.com/tkgstrator/Salmonia3/raw/develop/Resources/07.png") }, label: { Text(.HELP_IMPORT_RESULT).font(.custom("Splatfont2", size: 16)) })
        }
        .safariView(item: $url) { url in
            SafariView(url: url,
                       configuration: SafariView.Configuration(
                        entersReaderIfAvailable: false,
                        barCollapsingEnabled: true
                       )
            )
            .preferredBarAccentColor(.clear)
            .preferredControlAccentColor(.accentColor)
            .dismissButtonStyle(.done)
        }
        .navigationTitle(.TITLE_HELP)
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
