//
//  Firecode.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/02.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol Firecode: Codable, Identifiable {
    associatedtype DecodedType: Codable
    var id: String { get }
    var reference: DocumentReference { get }
}

extension Firecode {
    typealias DecodedType = Self
    
    func encoded() throws -> [String: Any] {
        try Firestore.Encoder().encode(self)
    }
}
