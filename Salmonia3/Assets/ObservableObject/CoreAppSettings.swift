//
//  CoreAppSettings.swift
//  Salmonia3
//
//  Created by Devonly on 3/13/21.
//

import Foundation
import RealmSwift
import SwiftUI

class CoreAppSetting: ObservableObject {
    @Published var isLogin: Bool = UserDefaults.standard.bool(forKey: "isLogin")
    @Published var account: RealmUserInfo = realm.objects(RealmUserInfo.self).first ?? RealmUserInfo()

//    var objectWillChange: ObservableObjectPublisher = .init()
    private static var realm = try! Realm()
    private var token: NSKeyValueObservation?

    init() {
        token = UserDefaults.standard.observe(\.isLogin, changeHandler: { [weak self] (defaults, change) in
            #warning("変わったときにチェックできるかどうか")
            self?.isLogin = UserDefaults.standard.bool(forKey: "isLogin")
        })
    }

}

extension UserDefaults {
    @objc dynamic var isLogin: Bool {
        return bool(forKey: "isLogin")
    }
}
