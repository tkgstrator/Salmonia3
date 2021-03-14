//
//  Int.swift
//  Salmonia3
//
//  Created by Devonly on 3/14/21.
//

import Foundation
import CryptoKit

private protocol ByteCountable {
    static var byteCount: Int { get }
}

extension Insecure.MD5: ByteCountable { }

extension String {
    var imageURL: String {
        return self.hash(algo: Insecure.MD5.self, using: String.Encoding.utf8)!
    }
    
    private func hash<Hash: HashFunction & ByteCountable>(algo: Hash.Type, using encoding: String.Encoding = .utf8) -> String? {
        guard let data = self.data(using: encoding) else {
            return nil
        }
        
        return algo.hash(data: data).prefix(algo.byteCount).map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
