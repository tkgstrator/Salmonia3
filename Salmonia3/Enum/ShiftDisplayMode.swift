//
//  ShiftDisplayMode.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/26.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation

enum ShiftDisplayMode: Int, CaseIterable, Identifiable {
    var id: Int { rawValue }
    /// 全シフト
    case all
    /// プレイ済み
    case played
    /// 現時点
    case current
}

extension ShiftDisplayMode {
    var description: String {
        switch self {
        case .all:
            return "全シフト"
        case .played:
            return "プレイ済みのみ"
        case .current:
            return "現在まで"
        }
    }
}
