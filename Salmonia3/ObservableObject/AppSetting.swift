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
    
    @Published var account: RealmUserInfo = RealmManager.shared.realm.objects(RealmUserInfo.self).first ?? RealmUserInfo()
    
    private var token: NSObserver = NSObserver()

    init() {
        guard let realm = try? Realm() else { return }
        token.realm = RealmManager.shared.realm.objects(RealmUserInfo.self).observe { _ in
            if let account = realm.objects(RealmUserInfo.self).first {
                self.account = account
            }
        }
    }
}

extension UserDefaults {
    @objc dynamic var isFirstLaunch: Bool {
        return bool(forKey: "isFirstLaunch")
    }
    @objc dynamic var FEATURE_FREE_01: Bool {
        return bool(forKey: "FEATURE_FREE_01")
    }
    @objc dynamic var FEATURE_FREE_02: Bool {
        return bool(forKey: "FEATURE_FREE_02")
    }
    @objc dynamic var FEATURE_FREE_03: Bool {
        return bool(forKey: "FEATURE_FREE_03")
    }
}

fileprivate struct NSObserver {
    var realm: NotificationToken?
}
