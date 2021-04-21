//
//  Keychain.swift
//  Salmonia3
//
//  Created by devonly on 2021/04/21.
//

import KeychainAccess

var keychain: Keychain {
    let server = "tkgstrator.work"
    return Keychain(server: server, protocolType: .https)
}

enum KeyType: String, CaseIterable {
    case iksmSession
    case sessionToken
    case playerId
    case nickname
    case thumbnailURL
}

extension Keychain {
    func setValue(value: String, forKey: KeyType) {
        try? keychain.set(value, key: forKey.rawValue)
    }
    
    func getValue(forKey: KeyType) -> String? {
        return try? keychain.get(forKey.rawValue)
    }

    func remove(forKey: KeyType) {
        try? keychain.remove(forKey.rawValue)
    }
}
