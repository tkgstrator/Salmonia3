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
            schemaVersion: 5,
            migrationBlock: { [self] migration, version in
                if version < 1 {
                    // マイグレーションブロック
                }
            })
        Realm.Configuration.defaultConfiguration = config
        try? RealmManager.addNewRotation()
    }
    
    public class func addNewAccount(account: RealmUserInfo) throws -> () {
        realm.beginWrite()
        realm.create(RealmUserInfo.self, value: account, update: .all)
        try realm.commitWrite()
    }

    public class func addNewResult(from data: JSON) throws -> () {
        let result = try JSONDecoder().decode(RealmCoopResult.self, from: data.rawData())
        realm.beginWrite()
        realm.create(RealmCoopResult.self, value: result, update: .all)
        try realm.commitWrite()
    }
    
    public class func addNewRotation() throws -> () {
        ProductManger.getFutureRotation { response, error in
            guard let response = response else { return }
            
            realm.beginWrite()
            for (_, data) in response {
                let value = try? JSONDecoder().decode(RealmCoopShift.self, from: data.rawData())
                realm.create(RealmCoopShift.self, value: value, update: .all)
            }
            try? realm.commitWrite()
        }
    }
}
