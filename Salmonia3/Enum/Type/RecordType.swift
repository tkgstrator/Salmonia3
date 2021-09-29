//
//  RecordType.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/29.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift

/// 記錄の種類を返すEnum
enum RecordType: Int, PersistableEnum, Codable {
    case total
    case nonight
    case wave
    
    var localizedName: String {
        switch self {
        case .total:
            return "NIGHT_WAVE".localized
        case .nonight:
            return "NO_NIGHT_WAVE".localized
        case .wave:
            return "WAVE_RECORD".localized
        }
    }
    
}

enum RecordTypeEgg: Int, PersistableEnum, Codable {
    case power
    case golden
}
