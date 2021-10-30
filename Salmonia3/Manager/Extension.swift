//
//  Extension.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/20.
//

import Foundation

extension String {
    /// ローカライズされた文字列を返す
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
