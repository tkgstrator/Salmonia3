//
//  SpecialType.swift
//  Salmonia3
//
//  Created by devonly on 2021/05/15.
//

import Foundation

enum SpecialType: Int, CaseIterable {
    case bombpitcher = 2
    case stingray = 7
    case inkjet = 8
    case splashdown = 9
}

extension SpecialType {
    var image: String {
        switch self {
        case .bombpitcher:
            return "88307509fb9d8a990a4bdd41e12a345c"
        case .stingray:
            return "03c6badf9b8995c873acba2f140988fa"
        case .inkjet:
            return "f244ad5b517e9af5f5be0b710a9803d8"
        case .splashdown:
            return "5c4a265d5d1dd51c7e5577f92d358cb4"
        }
    }
    
    var name: String {
        switch self {
        case .bombpitcher:
            return "Bomb pitcher"
        case .stingray:
            return "Sting ray"
        case .inkjet:
            return "Inkjet"
        case .splashdown:
            return "Splashdown"
        }
    }
}
