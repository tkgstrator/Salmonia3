//
//  PaidProductView.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/18.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI

struct PaidProductView: View {
    @EnvironmentObject var appManager: AppManager

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 140, maximum: 200)), count: 2), alignment: .center, spacing: nil, pinnedViews: [], content: {
                ForEach(appManager.allAvailableProducts, id:\.self) { product in
                    PurchaseButton(product: product)
                }
                RestoreButton()
                #if DEBUG
                LockButton()
                #endif
            })
        }
        .splatfont2(size: 16)
        .navigationTitle(.TITLE_PAID_PRODUCT)
    }
}

struct PaidProductView_Previews: PreviewProvider {
    static var previews: some View {
        PaidProductView()
    }
}
