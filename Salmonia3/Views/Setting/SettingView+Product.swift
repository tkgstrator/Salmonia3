//
//  SettingView+Product.swift
//  Salmonia3
//
//  Created by devonly on 2022/07/01.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftyUI

struct SettingView_Product: View {
    @State private var selection: Int? = 0
    private let productIds: [String] = ProductIdentifier.allCases

    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            ForEach(productIds, id: \.self) { productIdentifier in
                Text(productIdentifier)
                    .backgroundCard()
            }
        })
    }
}

struct ProductView: View {
    var body: some View {
        HStack(alignment: .center, spacing: nil, content: {
            Image(systemName: .BitcoinsignCircle)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60, alignment: .center)
            Text("広告を非表示にします")
                .font(systemName: .Splatfont2, size: 16)
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
        ProductView()
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 300, height: 120))
        ProductView()
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 375, height: 150))
        ProductView()
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 600, height: 240))
    }
}
