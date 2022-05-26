//
//  AppService.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/19.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SalmonStats
import SwiftUI
import SwiftyUI
import SplatNet2
import Common
import RealmSwift
import CocoaLumberjackSwift

final class AppService: ObservableObject {
    init() {
        let session = SalmonStats(refreshable: refreshable, requiredAPIToken: requiredAPIToken)
        self.version = session.version
        if realm.objects(RealmCoopShift.self).isEmpty {
            self.save(objects: SplatNet2.schedule.map({ RealmCoopShift(from: $0) }))
        }
    }
    
    /// アプリの外見の設定
    @Published var apperances: Appearances = Appearances.shared
    /// アプリの詳細の設定
    @Published var application: Application = Application.shared
    /// セッション
    @Published var version: String = "0.0.0"
    /// リザルト取得にAPITokenを必須にする
    @AppStorage("APP_REQUIRED_API_TOKEN") var requiredAPIToken: Bool = false
    /// 自動でAPIをアップデートする
    @AppStorage("APP_REFRESHABLE_TOKEN") var refreshable: Bool = false
    /// シフト表示モード
    @AppStorage("APP_SHIFT_DISPLAY_MODE") var shiftDisplayMode: ShiftDisplayMode = .current
    
    func save<T: Object>(objects: [T]) {
        if realm.isInWriteTransaction {
            realm.add(objects, update: .all)
        } else {
            realm.beginWrite()
            realm.add(objects, update: .all)
            try? realm.commitWrite()
        }
    }
    
    class Application {
        private init() {}
        static let shared: Application = Application()
        
        /// Application Version
        let appVersion: String = "\(String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!))(\(String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")!)))"
    }
    
    class Appearances {
        private init() {}
        static let shared: Appearances = Appearances()

        @AppStorage("APP.APPEARANCE.DARKMODE") var isDarkmode: Bool = false
        @AppStorage("APP.APPEARANCE.LISTSTYLE") var listStyle: ListStyle = .plain
        @AppStorage("APP.APPEARANCE.RESULTSTYLE") var resultStyle: ResultStyle = .line
        @AppStorage("APP.APPEARANCE.RESULTSTYLE") var refreshStyle: RefreshStyle = .button
        @AppStorage("APP.APPEARANCE.FONTSTYLE") var fontStyle: FontStyle = .Splatfont2
        @AppStorage("APP.APPEARANCE.COLORSTYLE") var colorStyle: ColorStyle = .default
        
        var colorScheme: ColorScheme {
            isDarkmode ? .dark : .light
        }
        
        /// フォントカラー
        enum ColorStyle: String, CaseIterable {
            case `default`
            case gaming
        }
        
        /// リザルト一覧表示スタイル
        enum ListStyle: String, CaseIterable {
            case plain
            case group
            case legacy
        }
        
        /// リザルトチャート表示スタイル
        enum ResultStyle: String, CaseIterable {
            case line
            case circle
        }
        
        /// リザルト更新方式
        enum RefreshStyle: String, CaseIterable {
            case pull
            case button
        }
    }
}

extension AppService.Appearances.ResultStyle: Identifiable {
    public var id: String { rawValue }
}

extension AppService.Appearances.ListStyle: Identifiable {
    public var id: String { rawValue }
}

extension AppService.Appearances.RefreshStyle: Identifiable {
    public var id: String { rawValue }
}
