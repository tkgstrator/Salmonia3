//
//  View.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/09.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    func navigationTitle(_ stringProtocol: LocalizableStrings.Key) -> some View {
        self.navigationTitle(stringProtocol.rawValue.localized)
    }
}
