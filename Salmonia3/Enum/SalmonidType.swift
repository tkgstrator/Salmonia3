//
//  SalmonidType.swift
//  Salmonia3
//
//  Created by devonly on 2021/05/15.
//

import Foundation

enum SalmonidType: Int, CaseIterable {
    case goldie     = 0
    case steelhead  = 1
    case flyfish    = 2
    case scrapper   = 3
    case steeleel   = 4
    case tower      = 5
    case maw        = 6
    case griller    = 7
    case drizzler   = 8
}

extension SalmonidType {
    var image: String {
        switch self {
        case .goldie:
            return "e7a2c9cae2301d8c1678a2aa4fadaba5"
        case .steelhead:
            return "4c86590828a4ca9271e25ccd799ab82f"
        case .flyfish:
            return "184b61a46145f2b7340eb65808b84a53"
        case .scrapper:
            return "b56adfe8983da6cfb3362a6975430a17"
        case .steeleel:
            return "9da9e56c0634bb7c6aa23dcaf96bc80a"
        case .tower:
            return "2e1473ff7deefbf5f834b71046271c9c"
        case .maw:
            return "fab43fc3b7a1d9fa6d204efd12589ae3"
        case .griller:
            return "9564445e3926734f256c44300dc1828d"
        case .drizzler:
            return "f28f0f0fe1e418c4da14403e44d1d1ea"
        }
    }
}
