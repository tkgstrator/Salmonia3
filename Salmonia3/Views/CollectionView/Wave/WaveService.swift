//
//  WaveService.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/26.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift
import SplatNet2
import Common
import SalmonStats

final class WaveService: ObservableObject {
    @Published var eventType: EventId? = .none
    @Published var waterLevel: WaterId? = .none
    @Published var nsaid: String
    @ObservedResults(
        RealmCoopWave.self,
        filter: nil,
        sortDescriptor: SortDescriptor(keyPath: "goldenIkuraNum", ascending: false)
    )
    var waves
    
    init() {
        let session: SalmonStats = SalmonStats()
        self.nsaid = session.account.credential.nsaid
    }
}
