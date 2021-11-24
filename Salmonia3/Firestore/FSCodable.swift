//
//  FSCodable.swift
//  Salmonia3
//
//  Created by devonly on 2021/11/23.
//

import Foundation
import CryptoKit

protocol FSCodable: Codable, Identifiable {
    var id: String { get }
    var startTime: Int { get }
}

extension FSCodable {
    var id: String {
        Insecure.SHA1.hash(data: Data(String(Date().timeIntervalSince1970).utf8))
        .compactMap({ String(format: "%02X", $0) }).joined()
    }
    var startTime: Int { 0 }
}
