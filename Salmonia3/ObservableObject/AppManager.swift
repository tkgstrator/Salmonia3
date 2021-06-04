//
//  AppManagers.swift
//  Salmonia3
//
//  Created by Devonly on 3/13/21.
//

import Foundation
import RealmSwift
import SwiftUI
import SplatNet2
import Combine

class AppManager: ObservableObject {
    
    @Published var account: RealmUserInfo = RealmManager.shared.realm.objects(RealmUserInfo.self).first ?? RealmUserInfo()
    
    // 無料機能
    @AppStorage("FEATURE_FREE_01") var isFree01: Bool = false // クマブキ表示
    @AppStorage("FEATURE_FREE_02") var isFree02: Bool = false // ローテーション表示
    @AppStorage("FEATURE_FREE_03") var isFree03: Bool = false // ニックネームを隠す
    @AppStorage("FEATURE_FREE_04") var isFree04: Bool = false // リストスタイル
    @AppStorage("FEATURE_FREE_05") var isFree05: Bool = false

    // 課金機能
    @AppStorage("FEATURE_PAID_01") var isPaid01: Bool = false
    @AppStorage("FEATURE_PAID_02") var isPaid02: Bool = false
    @AppStorage("FEATURE_PAID_03") var isPaid03: Bool = false
    @AppStorage("FEATURE_PAID_04") var isPaid04: Bool = false
    @AppStorage("FEATURE_PAID_05") var isPaid05: Bool = false

    // ゲーミング機能
    @AppStorage("FEATURE_GAME_01") var isGame01: Bool = false
    @AppStorage("FEATURE_GAME_02") var isGame02: Bool = false
    @AppStorage("FEATURE_GAME_03") var isGame03: Bool = false
    @AppStorage("FEATURE_GAME_04") var isGame04: Bool = false
    @AppStorage("FEATURE_GAME_05") var isGame05: Bool = false
    
    // その他の機能
    @AppStorage("FEATURE_OTHER_01") var isFirstLaunch: Bool = false // 初回起動かどうかのフラグ
    @AppStorage("FEATURE_OTHER_02") var importNum: Int = 50         // 一度にSalmon Statsから取得するリザルトの件数
    @AppStorage("FEATURE_OTHER_03") var isDarkMode: Bool = false    // ダークモード判定
    @AppStorage("FEATURE_OTHER_04") var isOther04: Bool = false     //
    @AppStorage("FEATURE_OTHER_05") var isOther05: Bool = false     //

    // デバッグ機能
    @AppStorage("FEATURE_DEBUG_01") var isDebugMode: Bool = false // ログ出力
    @AppStorage("FEATURE_DEBUG_02") var isDebug02: Bool = false //
    @AppStorage("FEATURE_DEBUG_03") var isDebug03: Bool = false //
    @AppStorage("FEATURE_DEBUG_04") var isDebug04: Bool = false //
    @AppStorage("FEATURE_DEBUG_05") var isDebug05: Bool = false // 

    private var token: NSObserver = NSObserver()
    private var observer: [[NSKeyValueObservation?]] = Array(repeating: Array(repeating: nil, count: 5), count: 5)
    
    init() {
        guard let realm = try? Realm() else { return }
        token.realm = realm.objects(RealmUserInfo.self).observe { _ in
            if let account = realm.objects(RealmUserInfo.self).first {
                self.account = account
            }
        }
        
        observer[0][0] = UserDefaults.standard.observe(\.FEATURE_PAID_01, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[0][1] = UserDefaults.standard.observe(\.FEATURE_PAID_02, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[0][2] = UserDefaults.standard.observe(\.FEATURE_PAID_03, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[0][3] = UserDefaults.standard.observe(\.FEATURE_PAID_04, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[0][4] = UserDefaults.standard.observe(\.FEATURE_PAID_05, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[1][0] = UserDefaults.standard.observe(\.FEATURE_FREE_01, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[1][1] = UserDefaults.standard.observe(\.FEATURE_FREE_02, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[1][2] = UserDefaults.standard.observe(\.FEATURE_FREE_03, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[1][3] = UserDefaults.standard.observe(\.FEATURE_FREE_04, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[1][4] = UserDefaults.standard.observe(\.FEATURE_FREE_05, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[2][0] = UserDefaults.standard.observe(\.FEATURE_GAME_01, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[2][1] = UserDefaults.standard.observe(\.FEATURE_GAME_02, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[2][2] = UserDefaults.standard.observe(\.FEATURE_GAME_03, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[2][3] = UserDefaults.standard.observe(\.FEATURE_GAME_04, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[2][4] = UserDefaults.standard.observe(\.FEATURE_GAME_05, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[3][0] = UserDefaults.standard.observe(\.FEATURE_DEBUG_01, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[3][1] = UserDefaults.standard.observe(\.FEATURE_DEBUG_02, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[3][2] = UserDefaults.standard.observe(\.FEATURE_DEBUG_03, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[3][3] = UserDefaults.standard.observe(\.FEATURE_DEBUG_04, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[3][4] = UserDefaults.standard.observe(\.FEATURE_DEBUG_05, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[4][0] = UserDefaults.standard.observe(\.FEATURE_OTHER_01, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[4][1] = UserDefaults.standard.observe(\.FEATURE_OTHER_02, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[4][2] = UserDefaults.standard.observe(\.FEATURE_OTHER_03, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[4][3] = UserDefaults.standard.observe(\.FEATURE_OTHER_04, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
        observer[4][4] = UserDefaults.standard.observe(\.FEATURE_OTHER_05, options: [.initial, .new], changeHandler: { [weak self] (_, _) in
            self?.objectWillChange.send()
        })
    }
    
    func loggingToCloud(_ value: String) {
        // ログ機能がオンの場合
        if isDebugMode {
            log.error("nsaid: \(String(describing: SplatNet2.shared.playerId!)), session: \(String(describing: SplatNet2.shared.iksmSession!)), apiver: \(SplatNet2.shared.version), value: \(value)")
        }
    }
}

// ログの収集別タイトル
enum LogType: String, CaseIterable {
    case getNickname
    case getResult
    case importResult
    case uploadResult
}

extension UserDefaults {
    @objc dynamic var FEATURE_FREE_01: Bool {
        return bool(forKey: "FEATURE_FREE_01")
    }
    @objc dynamic var FEATURE_FREE_02: Bool {
        return bool(forKey: "FEATURE_FREE_02")
    }
    @objc dynamic var FEATURE_FREE_03: Bool {
        return bool(forKey: "FEATURE_FREE_03")
    }
    @objc dynamic var FEATURE_FREE_04: Bool {
        return bool(forKey: "FEATURE_FREE_04")
    }
    @objc dynamic var FEATURE_FREE_05: Bool {
        return bool(forKey: "FEATURE_FREE_05")
    }
    @objc dynamic var FEATURE_PAID_01: Bool {
        return bool(forKey: "FEATURE_PAID_01")
    }
    @objc dynamic var FEATURE_PAID_02: Bool {
        return bool(forKey: "FEATURE_PAID_02")
    }
    @objc dynamic var FEATURE_PAID_03: Bool {
        return bool(forKey: "FEATURE_PAID_03")
    }
    @objc dynamic var FEATURE_PAID_04: Bool {
        return bool(forKey: "FEATURE_PAID_04")
    }
    @objc dynamic var FEATURE_PAID_05: Bool {
        return bool(forKey: "FEATURE_PAID_05")
    }
    @objc dynamic var FEATURE_GAME_01: Bool {
        return bool(forKey: "FEATURE_GAME_01")
    }
    @objc dynamic var FEATURE_GAME_02: Bool {
        return bool(forKey: "FEATURE_GAME_02")
    }
    @objc dynamic var FEATURE_GAME_03: Bool {
        return bool(forKey: "FEATURE_GAME_03")
    }
    @objc dynamic var FEATURE_GAME_04: Bool {
        return bool(forKey: "FEATURE_GAME_04")
    }
    @objc dynamic var FEATURE_GAME_05: Bool {
        return bool(forKey: "FEATURE_GAME_05")
    }
    @objc dynamic var FEATURE_DEBUG_01: Bool {
        return bool(forKey: "FEATURE_DEBUG_01")
    }
    @objc dynamic var FEATURE_DEBUG_02: Bool {
        return bool(forKey: "FEATURE_DEBUG_02")
    }
    @objc dynamic var FEATURE_DEBUG_03: Bool {
        return bool(forKey: "FEATURE_DEBUG_03")
    }
    @objc dynamic var FEATURE_DEBUG_04: Bool {
        return bool(forKey: "FEATURE_DEBUG_04")
    }
    @objc dynamic var FEATURE_DEBUG_05: Bool {
        return bool(forKey: "FEATURE_DEBUG_05")
    }
    @objc dynamic var FEATURE_OTHER_01: Bool {
        return bool(forKey: "FEATURE_OTHER_01")
    }
    @objc dynamic var FEATURE_OTHER_02: Bool {
        return bool(forKey: "FEATURE_OTHER_02")
    }
    @objc dynamic var FEATURE_OTHER_03: Bool {
        return bool(forKey: "FEATURE_OTHER_03")
    }
    @objc dynamic var FEATURE_OTHER_04: Bool {
        return bool(forKey: "FEATURE_OTHER_04")
    }
    @objc dynamic var FEATURE_OTHER_05: Bool {
        return bool(forKey: "FEATURE_OTHER_05")
    }
}

fileprivate struct NSObserver {
    var realm: NotificationToken?
}
