//
//  RealmUserInfo.swift
//  Salmonia3
//
//  Created by Devonly on 3/13/21.
//

import Foundation
import RealmSwift

class RealmUserInfo: Object {
    @objc dynamic var nsaid: String?
    @objc dynamic var nickname: String?
    @objc dynamic var thumbnailURL: String?
    @objc dynamic var sessionToken: String?
    @objc dynamic var iksmSession: String?
    @objc dynamic var isActive: Bool = false
    
    override static func primaryKey() -> String? {
        return "nsaid"
    }
}
