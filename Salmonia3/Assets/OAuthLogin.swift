//
//  OAuthLogin.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/12.
//

import Foundation
import CryptoKit

extension String {
    static var randomString: String {
        let letters: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<128).map { _ in letters.randomElement()! })
    }

    var base64EncodedString: String {
        return self.data(using: .utf8)!.base64EncodedString()
            .replacingOccurrences(of: "=", with: "")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
    }

    var codeChallenge: String {
        Data(SHA256.hash(data: Data(self.utf8))).base64EncodedString()
            .replacingOccurrences(of: "=", with: "")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
    }

    var oauthURL: URL {
        let auth_state: String = String.randomString
        let auth_code_challenge: String = self.codeChallenge
        let header: [String: String] = [
            "state": auth_state,
            "redirect_uri": "npf71b963c1b7b6d119://auth",
            "client_id": "71b963c1b7b6d119",
            "scope": "openid+user+user.birthday+user.mii+user.screenName",
            "response_type": "session_token_code",
            "session_token_code_challenge": auth_code_challenge,
            "session_token_code_challenge_method": "S256",
            "theme": "login_form"
        ]
        let url: String = "https://accounts.nintendo.com/connect/1.0.0/authorize?\(header.queryString)"
        return URL(string: url)!
    }

    func capture(pattern: String, group: Int) -> String? {
        let result = capture(pattern: pattern, group: [group])
        return result.isEmpty ? nil : result[0]
    }

    private func capture(pattern: String, group: [Int]) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
        guard let matched = regex.firstMatch(in: self, range: NSRange(location: 0, length: self.count)) else { return [] }
        return group.map { group -> String in
            return (self as NSString).substring(with: matched.range(at: group))
        }
    }

    var rawurlencode: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var urlencode: String {
        let charset = NSCharacterSet(charactersIn: "&:=\"#%/<>?@\\^`{|}+,! ").inverted
        return self.addingPercentEncoding(withAllowedCharacters: charset)!
    }

    func hmacsha1(key: String) -> String {
        let hash = HMAC<Insecure.SHA1>.authenticationCode(for: Data(self.data(using: .utf8)!), using: SymmetricKey(data: Data(key.data(using: .utf8)!)))
        let hashArray: [UInt8] = Array(hash.map { String(format: "%02x", $0) }).map { UInt8($0, radix: 16)! }
        let data: Data = Data(bytes: hashArray, count: hashArray.count)
        return data.base64EncodedString()
    }
}

extension Dictionary where Key == String, Value == String {
    var queryString: String {
        return self.sorted(by: { $0.0 < $1.0}).map { "\($0.0)=\($0.1)" }.joined(separator: "&")
    }

    var paramString: String {
        return self.sorted(by: { $0.0 < $1.0}).map { "\($0.0)=\($0.1.urlencode)" }.joined(separator: "&")
    }

    var query: String {
        return self.sorted(by: { $0.0 < $1.0}).map { "\($0.0)=\($0.1.urlencode)" }.joined(separator: ",")
    }

}
