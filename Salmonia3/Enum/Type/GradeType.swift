//
//  Grade.swift
//  Salmonia3
//
//  Created by tkgstrator on 3/16/21.
//

import Foundation
import SwiftUI

enum GradeType: Int, CaseIterable {
    case intern         = 0
    case apparentice    = 1
    case parttimer      = 2
    case gogetter       = 3
    case overachiver    = 4
    case profresshional = 5
    
    var localizedName: String {
        switch self {
        case .intern:
            return "Intern".localized
        case .apparentice:
            return "Apparentice".localized
        case .parttimer:
            return "Part-Timer".localized
        case .gogetter:
            return "Go-Getter".localized
        case .overachiver:
            return "Overachiver".localized
        case .profresshional:
            return "Profressional".localized
        }
    }
}
