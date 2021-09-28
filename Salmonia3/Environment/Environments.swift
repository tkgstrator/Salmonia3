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

        struct Wave: EnvironmentKey {
            static var defaultValue: RealmCoopWave = RealmCoopWave()
            
            typealias Value = RealmCoopWave
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
    
    var wave: RealmCoopWave {
        get {
            return self[Salmonia3.Environment.Wave.self]
        }
        set {
            self[Salmonia3.Environment.Wave.self] = newValue
        }
    }
}
