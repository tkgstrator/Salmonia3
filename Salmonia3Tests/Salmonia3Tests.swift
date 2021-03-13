//
//  Salmonia3Tests.swift
//  Salmonia3Tests
//
//  Created by Devonly on 2021/03/11.
//

import XCTest
@testable import Salmonia3

class Salmonia3Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        do {
            try HMACSHA1()
        } catch {
            
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func HMACSHA1() throws {
        // HMAC-SHA1のテストを行う
        let apiKey: String = "kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw"
        let apiKeySecret: String = "LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE"
        let requestURL: String = "https://api.twitter.com/1.1/statuses/update.json".urlencode
        let requestMethod: String = "POST".rawurlencode
        let signatureKey: String = "\(apiKey.rawurlencode)&\(apiKeySecret)"
        let timestamp: String = "1318622958"
        
        let parameters: [String: String] = [
            "status": "Hello Ladies + Gentlemen, a signed OAuth request!",
            "include_entities": "true",
            "oauth_consumer_key": "xvz1evFS4wEEPTGEFPHBog",
            "oauth_nonce": "kYjzVBB8Y0/Users/devonly/Desktop/Salmonia3/Salmonia3/LoginMenu/LoginMenu.swiftZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg",
            "oauth_signature_method": "HMAC-SHA1",
            "oauth_token": "370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb",
            "oauth_timestamp": timestamp,
            "oauth_version": "1.0"
        ]
        
        // パラメータ文字列のチェック
        let requestParams: String = parameters.paramString
        XCTAssertEqual(requestParams, "include_entities=true&oauth_consumer_key=xvz1evFS4wEEPTGEFPHBog&oauth_nonce=kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1318622958&oauth_token=370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb&oauth_version=1.0&status=Hello%20Ladies%20%2B%20Gentlemen%2C%20a%20signed%20OAuth%20request%21")
        
        // 署名文字列のチェック
        let signatureData: String = "\(requestMethod)&\(requestURL)&\(requestParams.urlencode)"
        XCTAssertEqual(signatureData, "POST&https%3A%2F%2Fapi.twitter.com%2F1.1%2Fstatuses%2Fupdate.json&include_entities%3Dtrue%26oauth_consumer_key%3Dxvz1evFS4wEEPTGEFPHBog%26oauth_nonce%3DkYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1318622958%26oauth_token%3D370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb%26oauth_version%3D1.0%26status%3DHello%2520Ladies%2520%252B%2520Gentlemen%252C%2520a%2520signed%2520OAuth%2520request%2521")
        
        // 署名のチェック
        XCTAssertEqual(signatureKey, "kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw&LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE")
        
        // OAuth署名のチェック
        XCTAssertEqual(signatureData.hmacsha1(key: signatureKey), "hCtSmYh+iHYCEqBWrE7C7hYmtUk=")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
