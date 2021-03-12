//
//  CoreRealmCoop.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/12.
//

import Foundation
import Realm
import RealmSwift
import Combine
import SwiftUI

class CoreRealmCoop: ObservableObject {
    var objectWillChange: ObservableObjectPublisher = .init()
    private static var realm = try! Realm()
    private var token: [NotificationToken] = []
    
    // 実際に使いそうなデータ
    @Published var results: RealmSwift.Results<RealmCoopResult> = realm.objects(RealmCoopResult.self)

    init() {
        token.append(results.observe { [weak self] _ in
            self?.objectWillChange.send()
        })
    }
}
