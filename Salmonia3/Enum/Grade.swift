//
//  Grade.swift
//  Salmonia3
//
//  Created by tkgstrator on 3/16/21.
//

import Foundation
import SwiftUI

enum SRGrade: Int, CaseIterable {
    case intern         = 0
    case apparentice    = 1
    case parttimer      = 2
    case gogetter       = 3
    case overachiver    = 4
    case profresshional = 5
}

extension SRGrade {
    var name: String {
        switch self {
        case .intern:
            return "Intern"
        case .apparentice:
            return "Apparentice"
        case .parttimer:
            return "Part-Timer"
        case .gogetter:
            return "Go-Getter"
        case .overachiver:
            return "Overachiver"
        case .profresshional:
            return "Profressional"
        }
    }
}
