//
//  TwitterOAuth.swift
//  Salmonia3
//
//  Created by Devonly on 3/13/21.
//

import Foundation
import SwiftyJSON
import Alamofire

class TwitterOAuth {
    private let apiKey: String = "FU3BPtinvqwcGpQMDChOnikMy"
    private static let apiKeySecret: String = "lzYuRtsuDmdk0gi2rYYG3IoZBRHyN3Hrdz405G6y3AuI1x35gP"
    private static var accessTokenSecret: String = ""
    public let callbackURL: String = "salmon-stats://"
    private let requestURL: String = "https://api.twitter.com/oauth/request_token".urlencode
    private let requestMethod: String = "POST".rawurlencode
    private let signatureKey: String = "\(apiKeySecret.rawurlencode)&\(accessTokenSecret.rawurlencode)"
    private let timestamp: String = "\(Int(Date().timeIntervalSince1970))"
    let header: HTTPHeaders
    
    // 署名情報を追加
    init() {
        var parameters: [String: String] = [
            "oauth_callback": callbackURL,
            "oauth_consumer_key": apiKey,
            "oauth_nonce": "yXdUByC8JeBJzlLzzpLZ76Cr0jXyWIph9dIS165ZQfWRpn8Tmj",
            "oauth_signature_method": "HMAC-SHA1",
            "oauth_timestamp": timestamp,
            "oauth_version": "1.0"
        ]
        
        let requestParams: String = parameters.paramString
        let signatureData: String = "\(requestMethod)&\(requestURL)&\(requestParams.urlencode)"
        let signature: String = signatureData.hmacsha1(key: signatureKey)
        
        // 署名を追加
        parameters["oauth_signature"] = signature
        header = ["Authorization": "OAuth \(parameters.query)"]
    }
    
    public func getOAuthURL(completion: @escaping([String: String]?, Error?)->()) {
        AF.request("https://api.twitter.com/oauth/request_token", method: .post, headers: header)
            .validate(statusCode: 200...200)
            .responseString { response in
                switch response.result {
                case .success(let value):
                    print(value)
                    guard let oauthToken: String = value.capture(pattern: "oauth_token=([0-9A-z-]*)", group: 1) else { return }
                    guard let oauthTokenSecret: String = value.capture(pattern: "secret=(.*)&", group: 1) else { return }
                    completion(["oauth_token": oauthToken, "oauth_token_secret": oauthTokenSecret], nil)
                case .failure(let error):
                    print(error)
                }
            }
    }
}
