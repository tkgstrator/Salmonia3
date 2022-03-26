//
//  WaveService.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/26.
//  
//

import Foundation
import RealmSwift
import SplatNet2
import Common

final class WaveService: ObservableObject {
    @Published var eventType: EventId? = .none {
        willSet {
            print(newValue)
            if let eventType = newValue {
                $waves.filter = NSPredicate("eventType", equal: eventType.key)
            }
        }
    }
    @Published var waterLevel: WaterId? = .none {
        willSet {
            if let waterLevel = newValue {
                $waves.filter = NSPredicate("waterLevel", equal: waterLevel)
            }
        }
    }
    @Published var nsaid: String?
    @ObservedResults(
        RealmCoopWave.self,
        filter: nil,
        sortDescriptor: SortDescriptor(keyPath: "goldenIkuraNum", ascending: false)
    )
    var waves
    
    init(account: UserInfo?) {
        self.nsaid = account?.credential.nsaid
    }
}
