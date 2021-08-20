//
//  Appearance.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/06/04.
//

import Foundation

enum ListStyle: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    case legacy     = "STYLE_LEGACY"
    case `default`     = "STYLE_DEFAULT"
    case sidebar    = "STYLE_SIDEBAR"
    case inset      = "STYLE_INSET"
}
