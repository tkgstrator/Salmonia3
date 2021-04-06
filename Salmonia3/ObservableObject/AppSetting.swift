//
//  AppSettingss.swift
//  Salmonia3
//
//  Created by Devonly on 3/13/21.
//

import Foundation
import RealmSwift
import SwiftUI

class AppSettings: ObservableObject {
//    @Published var isFirstLaunch: Bool = UserDefaults.standard.bool(forKey: "isFirstLaunch")
    #warning("アカウントをまるごともつか、個別にデータを持つかは悩みどころ")
    @Published var account: RealmUserInfo = realm.objects(RealmUserInfo.self).first ?? RealmUserInfo()

//    var objectWillChange: ObservableObjectPublisher = .init()
    private static var realm = try! Realm()
    private var token: NSKeyValueObservation?
    private var publish: NotificationToken?

    init() {
        guard let realm = try? Realm() else { return }
        token = UserDefaults.standard.observe(\.FEATURE_FREE_02, changeHandler: { [weak self] (_, _) in
            #warning("変わったときにチェックできるかどうか")
//            self?.isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
//            if let account = realm.objects(RealmUserInfo.self).first {
//                self?.account = account
//            }
        })
    }

}

extension UserDefaults {
    @objc dynamic var isFirstLaunch: Bool {
        return bool(forKey: "isFirstLaunch")
    }
    @objc dynamic var isFree01: Bool {
        return bool(forKey: "FEATURE_FREE_01")
    }
    @objc dynamic var FEATURE_FREE_02: Bool {
        return bool(forKey: "FEATURE_FREE_02")
    }
    @objc dynamic var isFree04: Bool {
        return bool(forKey: "FEATURE_FREE_03")
    }
}
