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
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

final class AppManager: ObservableObject {
    init() {
        do {
            self.realm = try Realm()
        } catch {
            var config = Realm.Configuration.defaultConfiguration
            config.deleteRealmIfMigrationNeeded = true
            config.schemaVersion = schemeVersion
            self.realm = try! Realm(configuration: config, queue: nil)
        }
        self.records = firestore.collection("records")
        self.connection = SalmonStats(userAgent: "Salmonia3/@tkgling")
        /// スケジュールを追加
        self.addLatestShiftSchedule()
        
        // 通知を受け取るように設定する
        Auth.auth().addStateDidChangeListener({ auth, user in
            self.user = user
        })
    }
    @Published private(set) var connection: SalmonStats
    /// Firestoreのユーザ情報
    @Published var user: FirebaseAuth.User?
    /// SalmonStatPlusの記録一覧
    @Published var waves: [FSRecordWave] = []
    /// リザルト取得中状態にするためのフラグ
    @Published var isLoading: Bool = false
    /// アプリの外見の設定
    @Published var apperances: Appearances = Appearances.shared
    /// アプリの詳細の設定
    @Published var application: Application = Application.shared
    /// Firestore接続用インスタンス
    internal let firestore: Firestore = Firestore.firestore()
    ///
    internal let records: CollectionReference
    /// Firestore用のEncoder
    internal let encoder: Firestore.Encoder = Firestore.Encoder()
    /// Firestore用のDecoder
    internal let decoder: Firestore.Decoder = Firestore.Decoder()
    /// ログイン用のProvider
    internal let provider = OAuthProvider(providerID: "twitter.com")
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

extension QuerySnapshot {
    internal func decode<T: FSCodable>(type: T.Type) -> [T] {
        self.documents.compactMap({ try? Firestore.Decoder().decode(T.self, from: $0.data()) })
    }
}

extension AppManager.Appearances.ResultStyle: Identifiable {
    public var id: String { rawValue }
}

extension AppManager.Appearances.ListStyle: Identifiable {
    public var id: String { rawValue }
}

extension AppManager.Appearances.RefreshStyle: Identifiable {
    public var id: String { rawValue }
}
