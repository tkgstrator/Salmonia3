//
//  StatsType.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/02.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation

protocol StatsType: Identifiable {
    var id: UUID { get }
    var score: Float { get }
    var other : Float { get }
}

enum StatsModel {}
