//
//  ProductInfo.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/04.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI

extension Setting.Sections {
    struct Product: View {
        var body: some View {
            Section(header: Text(.HEADER_PRODUCT).splatfont2(.safetyorange, size: 14)) {
                NavigationLink(destination: FreeProductView(), label: { Text(.SETTING_FREE_PRODUCT) })
                NavigationLink(destination: PaidProductView(), label: { Text(.SETTING_PAID_PRODUCT) })
            }
        }
    }
}

//struct ProductInfo_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductInfo()
//    }
//}
