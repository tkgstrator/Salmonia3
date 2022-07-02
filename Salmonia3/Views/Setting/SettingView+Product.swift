//
//  SettingView+Product.swift
//  Salmonia3
//
//  Created by devonly on 2022/07/01.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI

struct SettingView_Product: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            Section(content: {
                LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: nil, alignment: .center), count: 2), content: {
                    ForEach(ProductIdentifier.NonConsumable.allCases) { productId in
                        Text(productId.rawValue)
                    }
                    ForEach(ProductIdentifier.AutoRenewable.allCases) { productId in
                        Text(productId.rawValue)
                    }
                })
            }, header: {
                Text("追加機能")
            })
        })
    }
}

extension Image {
    init(from: ProductIdentifier.NonConsumable) {
        self.init(from.rawValue, bundle: .main)
    }
}

struct SettingView_Product_Previews: PreviewProvider {
    static var previews: some View {
        SettingView_Product()
    }
}
