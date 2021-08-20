//
//  View.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/05/19.
//

import Foundation
import SwiftUI

struct LocalizedTitle: ViewModifier {
    var localizedTitle: LocalizableStrings.Key
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(localizedTitle.rawValue.localized)
    }
}

extension View {
    func navigationTitle(_ content: LocalizableStrings.Key) -> some View {
        self.modifier(LocalizedTitle(localizedTitle: content))
    }
}
