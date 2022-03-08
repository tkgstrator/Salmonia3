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
    var reference: DocumentReference { get }
    static var path: String { get }
}

extension Firecode {
    func encoded() throws -> [String: Any] {
        try Firestore.Encoder().encode(self)
    }
}
