//
//  AppManager.swift
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

final class AppManager: SalmonStats {
    override init(version: String = "1.13.2") {
        do {
            self.realm = try Realm()
        } catch {
            var config = Realm.Configuration.defaultConfiguration
            config.deleteRealmIfMigrationNeeded = true
            config.schemaVersion = schemeVersion
            self.realm = try! Realm(configuration: config, queue: nil)
        }
        self.records = firestore.collection("records")
        super.init(version: version)
        
        // 通知を受け取るように設定する
        Auth.auth().addStateDidChangeListener({ auth, user in
            self.user = user
        })
    }
    /// Firestoreのユーザ情報
    @Published var user: FirebaseAuth.User?
    /// FireStatsの記録一覧
    @Published var waves: [FSRecordWave] = []
    /// リザルト取得中状態にするためのフラグ
    @Published var isLoading: Bool = false
    /// アプリの外見の設定
    @Published var apperances: Appearances = Appearances.shared
    /// アプリの詳細の設定
    @Published var application: Application = Application.shared
    /// Firestore接続用インスタンス
    private let firestore: Firestore = Firestore.firestore()
    ///
    internal let records: CollectionReference
    /// Firestore用のEncoder
    private let encoder: Firestore.Encoder = Firestore.Encoder()
    /// Firestore用のDecoder
    private let decoder: Firestore.Decoder = Firestore.Decoder()
    /// ログイン用のProvider
    private let provider = OAuthProvider(providerID: "twitter.com")
    /// RealmSwiftのScheme Version
    private let schemeVersion: UInt64 = 8192
    /// RealmSwiftのインスタンス
    private let realm: Realm

    /// PrimaryKeyを指定したオブジェクトを取得
    @discardableResult
    func object<T: Object>(ofType type: T.Type, forPrimaryKey key: String?) -> T? {
        realm.object(ofType: type, forPrimaryKey: key)
    }
    
    /// 指定したオブジェクトを全て取得
    @discardableResult
    func objecst<T: Object>(ofType type: T.Type) -> RealmSwift.Results<T> {
        realm.objects(type)
    }
    
    internal func twitterSignin() -> AnyPublisher<String, Error> {
        Future { [self] promise in
            provider.getCredentialWith(nil, completion: { credential, error in
                if let error = error {
                    promise(.failure(error))
                }
                
                if let credential = credential {
                    Auth.auth().signIn(with: credential, completion: { result, error in
                        if let error = error {
                            promise(.failure(error))
                        }
                        if let result = result, let userName = result.user.displayName {
                            promise(.success(userName))
                        }
                    })
                }
            })
        }
        .eraseToAnyPublisher()
    }
    
    internal func save<T: Object>(_ objects: [T]) {
        if realm.isInWriteTransaction {
            for object in objects {
                realm.create(T.self, value: object, update: .all)
            }
        } else {
            realm.beginWrite()
            for object in objects {
                realm.create(T.self, value: object, update: .all)
            }
            try? realm.commitWrite()
        }
    }
    
    internal func save<T: Object>(_ object: T) {
        if realm.isInWriteTransaction {
            realm.create(T.self, value: object, update: .all)
        } else {
            try? realm.write {
                realm.create(T.self, value: object, update: .all)
            }
        }
    }
    
    /// Firebaseにデータを保存
    private func create<T: FSCodable>(_ object: T, merge: Bool = false) throws {
        let data = try encoder.encode(object)
        firestore
            .collection("records")
            .document(String(format: "%10d", object.startTime))
            .collection("waves")
            .document(object.id).setData(data, merge: merge)
    }
    
    private func create<T: FSCodable>(_ objects: [T], merge: Bool = false) throws {
        for object in objects {
            try create(object, merge: merge)
        }
    }
    
    /// Firestoreにデータをアップロード
    internal func register(_ results: [(UploadResult.Response, Result.Response)]) {
        let records: [FSRecordWave] = results.flatMap({ result in result.1.waveDetails.map({ FSRecordWave(from: result.1, wave: $0, salmonId: result.0.salmonId) })})
        try? create(records)
    }
    
    /// Firebaseからデータをプライマリキーを指定して読み込み
    func object<T: FSCodable>(type: T.Type, primaryKey: String) -> AnyPublisher<T, SP2Error> {
        Future { [self] promise in
            firestore.collection(String(describing: T.self)).document(primaryKey).getDocument(completion: { [self] (document, _) in
                guard let document = document, let data = document.data() else {
                    promise(.failure(.Data(.response, nil)))
                    return
                }
                do {
                    promise(.success(try decoder.decode(T.self, from: data)))
                } catch {
                    promise(.failure(.Data(.undecodable, nil)))
                }
            })
        }
        .eraseToAnyPublisher()
    }
    
    /// Firebaseから指定した型のデータを全て取得
    func objects<T: FSCodable>(_ type: T.Type) -> AnyPublisher<[T], SP2Error> {
        Future { [self] promise in
            firestore
                .collection(String(describing: T.self))
                .getDocuments(completion: { [self] (snapshot, _) in
                if let snapshot = snapshot, !snapshot.documents.isEmpty {
                    promise(.success(snapshot.documents.compactMap({ try? decoder.decode(T.self, from: $0.data()) })))
                }
            })
        }
        .eraseToAnyPublisher()
    }
    
    /// シフト情報をRealmに追加
    func addLatestShiftSchedule() {
        save(SplatNet2.schedule.map({ RealmCoopShift(from: $0) }))
    }
    
    class Application {
        private init() {}
        static let shared: Application = Application()
        
        /// Application Version
        let appVersion: String = "\(String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!))(\(String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")!)))"
        /// X-Product Version
        let apiVersion: String = "1.13.2"
    }
    
    class Appearances {
        private init() {}
        static let shared: Appearances = Appearances()

        @AppStorage("APP_APPEARANCE_DARKMODE") var isDarkmode: Bool = false
        @AppStorage("APP_APPEARANCE_LISTSTYLE") var listStyle: ListStyle = .plain
        @AppStorage("APP_APPEARANCE_RESULTSTYLE") var resultStyle: ResultStyle = .line
        @AppStorage("APP_APPEARANCE_RESULTSTYLE") var refreshStyle: RefreshStyle = .button
        @AppStorage("APP_APPEARANCE_FONTSTYLE") var fontStyle: FontStyle = .Splatfont2
        @AppStorage("APP_APPEARANCE_COLORSTYLE") var colorStyle: ColorStyle = .default
        
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

/// AppStorageで配列を保存するためのExtension
extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
