//
//  Text.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/05/19.
//

import Foundation
import SwiftUI

extension Text {
    
    init(_ content: LocalizableStrings.Key) {
        self.init(content.rawValue.localized)
    }
    
}
