//
//  Appearance.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/06/04.
//

import Foundation
import SwiftUI

/// リザルト表示のリスト形式
enum ResultListStyle: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    case legacy     = "STYLE_LEGACY"
    case plain      = "STYLE_PLAIN"
    case grouped    = "STYLE_GROUPED"
    case `default`  = "STYLE_DEFAULT"
    case sidebar    = "STYLE_SIDEBAR"
    case inset      = "STYLE_INSET"
}

enum ResultStyle: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    case salmonrec  = "STYLE_LEGACY"
    case barleyural = "STYLE_BARLEY"
    case lemontea   = "STYLE_LEMON"
    case `default`  = "STYLE_DEFAULT"
}
