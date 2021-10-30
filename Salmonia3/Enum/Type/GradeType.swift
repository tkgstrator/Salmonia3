//
//  Grade.swift
//  Salmonia3
//
//  Created by tkgstrator on 3/16/21.
//

import Foundation
import RealmSwift
import SwiftUI

enum GradeType: Int, CaseIterable, PersistableEnum {
    /// けんしゅう
    case intern         = 0
    /// かけだし
    case apparentice    = 1
    /// はんにんまえ
    case parttimer      = 2
    /// いちにんまえ
    case gogetter       = 3
    /// じゅくれん
    case overachiver    = 4
    /// たつじん
    case profresshional = 5
    
    var localized: String {
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
