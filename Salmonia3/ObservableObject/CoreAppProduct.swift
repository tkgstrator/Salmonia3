//
//  CoreProduct.swift
//  Salmonia3
//
//  Created by devonly on 2021/04/06.
//

import Foundation
import SwiftUI

class CoreAppProduct: ObservableObject {
    // MARK: - 無料機能
    static let defaults = UserDefaults.standard
    @AppStorage("FEATURE_FREE_01") var isFree01: Bool = false
    @AppStorage("FEATURE_FREE_02") var isFree02: Bool = false
//    @Published var isFree02: Bool = defaults.bool(forKey: "FEATURE_FREE_02")
//    @AppStorage("FEATURE_FREE_02") var isFree02: Bool = false
    @AppStorage("FEATURE_FREE_03") var isFree03: Bool = false
    @AppStorage("FEATURE_FREE_04") var isFree04: Bool = false
    @AppStorage("FEATURE_FREE_05") var isFree05: Bool = false

    // MARK: - 有料機能
    @AppStorage("FEATURE_PAID_01") var isPaid01: Bool = false
    @AppStorage("FEATURE_PAID_02") var isPaid02: Bool = false
    @AppStorage("FEATURE_PAID_03") var isPaid03: Bool = false
    @AppStorage("FEATURE_PAID_04") var isPaid04: Bool = false
    @AppStorage("FEATURE_PAID_05") var isPaid05: Bool = false

    // MARK: - ゲーミング機能
    @AppStorage("FEATURE_GAME_01") var isGame01: Bool = false
    @AppStorage("FEATURE_GAME_02") var isGame02: Bool = false
    @AppStorage("FEATURE_GAME_03") var isGame03: Bool = false
    @AppStorage("FEATURE_GAME_04") var isGame04: Bool = false
    @AppStorage("FEATURE_GAME_05") var isGame05: Bool = false
}
