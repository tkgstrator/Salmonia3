//
//  Record.swift
//  Salmonia3
//
//  Created by devonly on 2021/11/23.
//

import Foundation
import SplatNet2

struct FireRecord: FSCodable {
    let goldenEggs: Int
    let powerEggs: Int
    let eventType: Result.EventType
    let waterLevel: Result.WaterLevel
}
