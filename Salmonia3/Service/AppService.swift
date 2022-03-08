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
import StoreKit
import SwiftyStoreKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

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
        self.session = SalmonStats(refreshable: true)
        /// スケジュールを追加
        self.session.delegate = self
        /// アカウントを設定
        self.account = self.session.account
        /// シフト情報を更新
        self.addLatestShiftSchedule()
        /// FirebaseAuth
        Auth.auth().addStateDidChangeListener({ (auth, user) in
            self.user = user
        })
        
        /// プロダクト情報を取得
        SwiftyStoreKit.retrieveProductsInfo(productIdentifiers, completion: { result in
            self.products = result.retrievedProducts
        })
    }
    /// アカウント情報
    @Published var account: Common.UserInfo? = nil
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
    /// アプリの課金情報
    private let productIdentifiers: Set<String> = [
        "work.tkgstrator.salmonia3.chip500",
        "work.tkgstrator.salmonia3.chip980"
    ]
    /// 課金コンテンツ情報
    @Published var products: Set<SKProduct> = Set<SKProduct>()
    /// シフト表示モード
    @AppStorage("APP_SHIFT_DISPLAY_MODE") var shiftDisplayMode: ShiftDisplayMode = .current
    /// Firestore
    internal let firestore: Firestore = Firestore.firestore()
    internal let encoder: Firestore.Encoder = Firestore.Encoder()
    internal let decoder: Firestore.Decoder = Firestore.Decoder()
    internal let provider: OAuthProvider = OAuthProvider(providerID: "twitter.com")
    /// Firebaseユーザ
    @Published var user: FirebaseAuth.User?
    /// Firestore連携フラグ
    @AppStorage("APP.FIRESTORE.ISSIGNIN") var isConnected: Bool = false
    /// SalmonStats連携フラグ
    @AppStorage("APP.SALMONSTATS.UPDATED") var uploaded: Bool = false
    
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
