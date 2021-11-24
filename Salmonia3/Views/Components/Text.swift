//
//  Text.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/24.
//

import Foundation
import SwiftUI
import SplatNet2

extension Text {
    init(_ grade: Result.GradeId?) {
        self.init(grade.gradeName)
    }
    
    init(_ value: Int?) {
        if let value = value {
            self.init("\(value)")
        } else {
            self.init("-")
        }
    }
    
    init(_ value: Int) {
        self.init("\(value)")
    }
}

extension Optional where Wrapped == Result.GradeId {
    var gradeName: String {
        switch self {
            case .profreshional:
                return "Profreshional"
            case .overachiver:
                return "Over achiver"
            case .gogetter:
                return "Go getter"
            case .parttimer:
                return "Part timer"
            case .apparentice:
                return "Apparentice"
            case .intern:
                return "Intern"
            case .none:
                return "Intern"
        }
    }
}
