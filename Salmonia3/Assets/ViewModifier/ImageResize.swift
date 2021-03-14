//
//  ImageResize.swift
//  Salmonia3
//
//  Created by Devonly on 3/14/21.
//

import Foundation
import SwiftUI

extension Image {
    func resize() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 18, height: 18)
    }
}
