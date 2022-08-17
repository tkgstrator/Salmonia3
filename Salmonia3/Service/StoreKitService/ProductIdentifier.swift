//
//  ProductIdentifier.swift
//  Salmonia3
//
//  Created by devonly on 2022/07/02.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftyUI
import StoreKit

enum ProductIdentifier {
    enum Consumable: String, CaseIterable, Identifiable {
        var id: String { rawValue }

        case chip500 = "work.tkgstrator.salmonia3.chip500"
        case chip980 = "work.tkgstrator.salmonia3.chip980"
    }

    enum NonConsumable: String, CaseIterable, Identifiable {
        var id: String { rawValue }

        case multiaccount   = "work.tkgstrator.multiaccounts"
        case disableads     = "work.tkgstrator.disableads"
    }

    enum AutoRenewable: String, CaseIterable, Identifiable {
        var id: String { rawValue }

        case apiupdate = "work.tkgstrator.upgradeapi"
        case premium   = "work.tkgstrator.premium"
    }

    enum Renewable: String, CaseIterable {
        case unknown
    }

    static var allCases: [String] {
        let allCases: [String] = ProductIdentifier.Consumable.allCases.map({$0.rawValue})
        + ProductIdentifier.NonConsumable.allCases.map({$0.rawValue})
        + ProductIdentifier.AutoRenewable.allCases.map({$0.rawValue})
        return allCases
    }
}

extension Image {
    init(productId: String) {
        if let product = ProductIdentifier.AutoRenewable(rawValue: productId) {
            switch product {
            case .apiupdate:
                self.init(StickersType.squid)
                return
            case .premium:
                self.init(StickersType.squid)
                return
            }
        }
        if let product = ProductIdentifier.NonConsumable(rawValue: productId) {
            switch product {
            case .disableads:
                self.init(StickersType.splatted)
                return
            case .multiaccount:
                self.init(StickersType.party)
                return
            }
        }
        if let product = ProductIdentifier.Consumable(rawValue: productId) {
            switch product {
            case .chip500:
                self.init(StickersType.flow)
                return
            case .chip980:
                self.init(StickersType.flow)
                return
            }
        }
        self.init(systemName: .BitcoinsignCircle)
    }
}
