//
//  RealmManager.swift
//  Salmonia3
//
//  Created by Devonly on 3/13/21.
//

import Foundation
import RealmSwift
import SwiftyJSON

class RealmManager {
    static let realm = try! Realm()
    
    init() {
        // データベースのマイグレーションをする
        let config = Realm.Configuration(
            schemaVersion: 4,
            migrationBlock: { [self] migration, version in
                if version < 1 {
                    // マイグレーションブロック
                }
            })
        Realm.Configuration.defaultConfiguration = config
    }
    
    public class func addNewAccount(account: RealmUserInfo) throws -> () {
        realm.beginWrite()
        realm.create(RealmUserInfo.self, value: account, update: .all)
        try realm.commitWrite()
    }

    public class func addNewResult(result: RealmCoopResult) throws -> () {
        realm.beginWrite()
        realm.create(RealmCoopResult.self, value: result, update: .all)
        try realm.commitWrite()
    }
    
}
