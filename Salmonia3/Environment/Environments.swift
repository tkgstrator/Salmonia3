//
//  Environments.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/22.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI
import RealmSwift

class Salmonia3 {
    class Environment {
        struct CoopShift: EnvironmentKey {
            static var defaultValue: RealmCoopShift = RealmCoopShift()
            
            typealias Value = RealmCoopShift
        }
    }
}

extension EnvironmentValues {
    var coopshift: RealmCoopShift {
        get {
            return self[Salmonia3.Environment.CoopShift.self]
        }
        set {
            self[Salmonia3.Environment.CoopShift.self] = newValue
        }
    }
}
