//
//  Image.swift
//  Salmonia3
//
//  Created by devonly on 2021/11/23.
//

import Foundation
import SwiftUI
import SplatNet2

extension Image {
    init(_ stageId: Result.StageType.StageId) {
        self.init("Stage/\(stageId.rawValue)", bundle: .main)
    }
}
