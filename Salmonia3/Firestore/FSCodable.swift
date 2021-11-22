//
//  FSCodable.swift
//  Salmonia3
//
//  Created by devonly on 2021/11/23.
//

import Foundation

protocol FSCodable: Codable, Identifiable {
    var id: String? { get }
}

extension FSCodable {
    var id: String? { nil }
}
