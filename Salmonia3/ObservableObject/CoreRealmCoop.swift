//
//  CoreRealmCoop.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/12.
//

import Foundation
import RealmSwift
import Combine
import SwiftUI

class CoreRealmCoop: ObservableObject {
    private static var realm = try! Realm()
    private var token: NSObserver = NSObserver()

    // 実際に使いそうなデータ
    @Published var results: RealmSwift.Results<RealmCoopResult> = realm.objects(RealmCoopResult.self).sorted(byKeyPath: "playTime", ascending: false)
    @Published var shifts: RealmSwift.Results<RealmCoopShift> = realm.objects(RealmCoopShift.self).sorted(byKeyPath: "startTime", ascending: false)
    @AppStorage("FEATURE_FREE_02") var isFree02: Bool = false

    private func rotationObserver() {
        // 将来のシフト表示が切り替わったとき
        token.futureRotation = UserDefaults.standard.observe(\.FEATURE_FREE_02, options: [.initial, .new], changeHandler: { [self] (_, _) in
            switch isFree02 {
            case true:
                // 全部表示
                shifts = CoreRealmCoop.realm.objects(RealmCoopShift.self).sorted(byKeyPath: "startTime", ascending: false)
            case false:
                // 一部だけ表示
                let currentTime: Int = Int(Date().timeIntervalSince1970)
                guard let nextShiftStartTime: Int = CoreRealmCoop.realm.objects(RealmCoopShift.self)
                    .sorted(byKeyPath: "startTime", ascending: true)
                    .filter("startTime>=%@", currentTime)
                    .first?.startTime else { return }
                shifts = CoreRealmCoop.realm.objects(RealmCoopShift.self)
                    .sorted(byKeyPath: "startTime", ascending: false)
                    .filter("startTime<=%@", nextShiftStartTime)
            }
        })

    }

    init() {
        token.realm = try? Realm().objects(RealmCoopResult.self).observe { [self] _ in
            rotationObserver()
            results = CoreRealmCoop.realm.objects(RealmCoopResult.self).sorted(byKeyPath: "playTime", ascending: false)
        }
        
        token.realm = try? Realm().objects(RealmUserInfo.self).observe { [self] _ in
            rotationObserver()
            results = CoreRealmCoop.realm.objects(RealmCoopResult.self).sorted(byKeyPath: "playTime", ascending: false)
        }
    }

    deinit {
        token.futureRotation?.invalidate()
    }
}

fileprivate struct NSObserver {
    var realm: NotificationToken?
    var rareWeapon: NSKeyValueObservation?
    var futureRotation: NSKeyValueObservation?
}
