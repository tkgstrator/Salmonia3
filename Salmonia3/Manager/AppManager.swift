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

final class AppManager: SalmonStats, ObservableObject {
    override init(version: String = "1.13.2") {
        do {
            self.realm = try Realm()
        } catch {
            var config = Realm.Configuration.defaultConfiguration
            config.deleteRealmIfMigrationNeeded = true
            config.schemaVersion = schemeVersion
            self.realm = try! Realm(configuration: config, queue: nil)
        }
        super.init(version: "1.13.2")
    }
    
    @Published var isLoading: Bool = false
    /// アプリの外見の設定
    @Published var apperances: Appearances = Appearances.shared
    /// アプリの詳細の設定
    @Published var application: Application = Application.shared
    /// Firestore接続用インスタンス
    private let firestore: Firestore = Firestore.firestore()
    /// Firestore用のEncoder
    private let encoder: Firestore.Encoder = Firestore.Encoder()
    /// Firestore用のDecoder
    private let decoder: Firestore.Decoder = Firestore.Decoder()
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
    
    
//    func save(_ results: [SplatNet2.Coop.Result]) {
//        let objects: [RealmCoopResult] = results.map({ RealmCoopResult(from: $0, pid: playerId)})
//        self.save(objects)
//    }
    
    private func save<T: Object>(_ objects: [T]) {
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
    
    private func save<T: Object>(_ object: T) {
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
        if let primaryKey = object.id {
            firestore.collection(String(describing: T.self)).document(primaryKey).setData(data, merge: merge)
        } else {
            firestore.collection(String(describing: T.self)).document().setData(data, merge: merge)
        }
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
