//
//  RealmUserInfo.swift
//  Salmonia3
//
//  Created by Devonly on 3/13/21.
//

import Foundation
import RealmSwift
import SplatNet2

class RealmUserInfo: Object {
    @objc dynamic var nsaid: String?
    @objc dynamic var nickname: String?
    @objc dynamic var thumbnailURL: String?
    @objc dynamic var sessionToken: String?
    @objc dynamic var iksmSession: String?
    @objc dynamic var isActive: Bool = false
    @objc dynamic var jobNum: Int = 0
    @objc dynamic var goldenIkuraTotal: Int = 0
    @objc dynamic var helpTotal: Int = 0
    @objc dynamic var ikuraTotal: Int = 0
    @objc dynamic var kumaPoint: Int = 0
    @objc dynamic var kumaPointTotal: Int = 0
    
    override static func primaryKey() -> String? {
        return "nsaid"
    }
    
    required convenience init(from account: Response.UserInfo) {
        self.init()
        self.nsaid = account.nsaid
        self.nickname = account.nickname
        self.thumbnailURL = account.imageUri
        self.iksmSession = account.iksmSession
        self.sessionToken = account.sessionToken
    }
}
