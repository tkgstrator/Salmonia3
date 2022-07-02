//
//  ProductIdentifier.swift
//  Salmonia3
//
//  Created by devonly on 2022/07/02.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation

enum ProductIdentifier {
    enum Consumable: String, CaseIterable, Identifiable {
        var id: String { rawValue }

        case chip500 = "work.tkgstrator.salmonia3.chip500"
        case cnip980 = "work.tkgstrator.salmonia3.chip980"
    }

    enum NonConsumable: String, CaseIterable, Identifiable {
        var id: String { rawValue }

        case multiaccount = "work.tkgstrator.multiaccounts"
        case disableads = "work.tkgstrator.disableads"
    }

    enum AutoRenewable: String, CaseIterable, Identifiable {
        var id: String { rawValue }

        case apiupdate = "work.tkgstrator.upgradeapi"
    }

    enum Renewable: String, CaseIterable {
        case unknown
    }
}
