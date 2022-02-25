//
//  service.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/19.
//

import Foundation
import SalmonStats
import Combine
import SwiftUI
import SwiftyUI
import SplatNet2
import RealmSwift
import Common

final class AppService: ObservableObject {
    init() {
        do {
            self.realm = try Realm()
        } catch {
            var config = Realm.Configuration.defaultConfiguration
            config.deleteRealmIfMigrationNeeded = true
            config.schemaVersion = schemeVersion
            self.realm = try! Realm(configuration: config, queue: nil)
        }
        self.session = SalmonStats()
        /// スケジュールを追加
        self.session.delegate = self
        /// アカウントを設定
        self.account = self.session.account
        /// シフト情報を更新
        self.addLatestShiftSchedule()
    }
    /// アカウント情報
    @Published var account: UserInfo? = nil
    /// サインイン中であることを表示
    @Published var isSignIn: Bool = false
    /// サインイン中の状態
    @Published var signInState: SignInState? = .none
    /// セッション
    @Published var session: SalmonStats
    /// リザルト取得中状態にするためのフラグ
    @Published var isLoading: Bool = false
    /// ダウンロードの進捗
    @Published var progress: ProgressModel?
    /// 受け取ったエラーの内容
    @Published var sp2Error: SP2Error? {
        willSet {
            if let _ = newValue {
                isErrorPresented = true
            } else {
                isErrorPresented = false
            }
        }
    }
    /// 受け取ったエラーを表示しているかどうかのフラグ
    @Published var isErrorPresented: Bool = false
    /// アプリの外見の設定
    @Published var apperances: Appearances = Appearances.shared
    /// アプリの詳細の設定
    @Published var application: Application = Application.shared
    /// RealmSwiftのScheme Version
    private let schemeVersion: UInt64 = 8192
    /// RealmSwiftのインスタンス
    internal let realm: Realm
    
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
