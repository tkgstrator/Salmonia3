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
    @Published var results: RealmSwift.Results<RealmCoopResult> = realm.objects(RealmCoopResult.self).sorted(byKeyPath: "startTime", ascending: false)
    @Published var shifts: RealmSwift.Results<RealmCoopShift> = realm.objects(RealmCoopShift.self).sorted(byKeyPath: "startTime", ascending: false)
    
    init() {
        token.append(results.observe { [weak self] _ in
            self!.results = CoreRealmCoop.realm.objects(RealmCoopResult.self).sorted(byKeyPath: "startTime", ascending: false)
        })

        token.append(shifts.observe { [weak self] _ in
            self!.shifts = CoreRealmCoop.realm.objects(RealmCoopShift.self).sorted(byKeyPath: "startTime", ascending: false)
        })
    }
}
