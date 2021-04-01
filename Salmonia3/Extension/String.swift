//
//  String.swift
//  Salmonia3
//
//  Created by Devonly on 3/14/21.
//

import Foundation

#warning("ローカライズするだけの意味なさげなExtension")
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
