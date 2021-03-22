//
//  RealmUserInfo.swift
//  Salmonia3
//
//  Created by Devonly on 3/13/21.
//

import Foundation
import RealmSwift

class RealmUserInfo: Object, Decodable {
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
    
    private enum CodingKeys: String, CodingKey {
        case nickname           = "nickname"
        case userinfo           = "user"
        case thumbnailURL       = "thumbnail_url"
        case sessionToken       = "session_token"
        case iksmSession        = "iksm_session"
        case jobNum             = "job_num"
        case goldenIkuraTotal   = "golden_ikura_total"
        case helpTotal          = "help_total"
        case ikuraTotal         = "ikura_total"
        case kumaPoint          = "kuma_point"
        case kumaPointTotal     = "kuma_point_total"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let nickname = try container.decodeIfPresent(String.self, forKey: .nickname) {
        }
        
        if let user = try container.decodeIfPresent(UserInfo.self, forKey: .userinfo) {
            self.nickname = user.nickname
            self.thumbnailURL = user.thumbnail_url
        }
        
        if let thumbnailURL = try container.decodeIfPresent(String.self, forKey: .thumbnailURL) {
            self.thumbnailURL = thumbnailURL
        }
        
        if let sessionToken = try container.decodeIfPresent(String.self, forKey: .sessionToken) {
            self.sessionToken = sessionToken
        }
        
        if let iksmSession = try container.decodeIfPresent(String.self, forKey: .iksmSession) {
            self.iksmSession = iksmSession
        }
        
        if let jobNum = try container.decodeIfPresent(Int.self, forKey: .jobNum) {
            self.jobNum = jobNum
        }
        
        if let goldenIkuraTotal = try container.decodeIfPresent(Int.self, forKey: .goldenIkuraTotal) {
            self.goldenIkuraTotal = goldenIkuraTotal
        }
        
        if let helpTotal = try container.decodeIfPresent(Int.self, forKey: .helpTotal) {
            self.helpTotal = helpTotal
        }
        
        if let ikuraTotal = try container.decodeIfPresent(Int.self, forKey: .ikuraTotal) {
            self.ikuraTotal = ikuraTotal
        }
        
        if let kumaPoint = try container.decodeIfPresent(Int.self, forKey: .kumaPoint) {
            self.kumaPoint = kumaPoint
        }
        
        if let kumaPointTotal = try container.decodeIfPresent(Int.self, forKey: .kumaPointTotal) {
            self.kumaPointTotal = kumaPointTotal
        }
        
    }
    
    private class UserInfo: Codable {
        var thumbnail_url: String = ""
        var nickname: String = ""
    }
}
