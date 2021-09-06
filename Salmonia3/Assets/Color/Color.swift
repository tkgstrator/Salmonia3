//
//  Color.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/03/11.
//

import Foundation
import SwiftUI

enum EXColor: String, CaseIterable {
    public enum Package {
        public static let namespace = "Color"
        public static let version = "1.0.0"
    }
    
    case blackrussian   = "#0A1128"
    case dodgerblue     = "#1DA1FF"
    case sapphire       = "#001F54"
    case maire          = "#2A270B"
    case easternblue    = "#1282A2"
    case seashell       = "#FEFCFB"
    case safetyorange   = "#FF7500"
    case turbo          = "#F7CA18"
    case venitianred    = "#CF000F"
    case deepskyblue    = "#19B5FE"
    case salam          = "#1E824C"
    case moonyellow     = "#E9C71D"
    case dimgray        = "#707070"
    
    public var colorCode: String {
        "\(Package.namespace)/\(rawValue)"
    }
}

extension Color {
    init(_ symbol: EXColor) {
        self.init(symbol.colorCode, bundle: .main)
    }
}

extension Color {
    static let blackrussian     = Color(.blackrussian)
    static let dodgerblue       = Color(.dodgerblue)
    static let sapphire         = Color(.sapphire)
    static let maire            = Color(.maire)
    static let easternblue      = Color(.easternblue)
    static let seashell         = Color(.seashell)
    static let safetyorange     = Color(.safetyorange)
    static let turbo            = Color(.turbo)
    static let venitianred      = Color(.venitianred)
    static let deepskyblue      = Color(.deepskyblue)
    static let salam            = Color(.salam)
    static let moonyellow       = Color(.moonyellow)
    static let dimgray          = Color(.dimgray)
}

extension Color {
    public static var random: Color {
        return Color(red: .random(), green: .random(), blue: .random())
    }
}

extension Double {
    static func random() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX)
    }
}
