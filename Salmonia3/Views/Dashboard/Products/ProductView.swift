//
//  SettingView+Product.swift
//  Salmonia3
//
//  Created by devonly on 2022/07/01.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftyUI
import StoreKit

struct ProductView: View {
    @EnvironmentObject var service: StoreKitService

    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: nil, alignment: .top), count: 2), spacing: 24, content: {
                ForEach(service.retrieveProducts) { product in
                    ProductItem(product: product)
                }
                RestoreItem()
            })
        })
        .navigationTitle("追加機能")
        .navigationBarTitleDisplayMode(.inline)
        .environmentObject(LoadingService())
        .font(systemName: .Splatfont2, size: 16)
    }
}

extension ProductView {
    struct RestoreItem: View {
        @EnvironmentObject var service: StoreKitService

        var body: some View {
            VStack(content: {
                ZStack(alignment: .bottom, content: {
                    Button(action: {
                        service.restorePurchasedProducts()
                    }, label: {
                        Image(StickersType.lijudd)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .background(Circle())
                            .overlay(Circle().strokeBorder(.white, lineWidth: 4, antialiased: true))
                    })
                    Text("Restore")
                        .foregroundColor(.primary)
                        .shadow(color: .blue, radius: 1, x: 1, y: 1)
                        .lineLimit(1)
                        .font(systemName: .Splatfont2, size: 20)
                })
            })
        }
    }

    struct ProductItem: View {
        @EnvironmentObject var service: StoreKitService
        var isEnabled: Bool {
            UserDefaults.standard.bool(forKey: product.productIdentifier)
        }
        let product: SKProduct

        var body: some View {
            VStack(content: {
                ZStack(alignment: .bottom, content: {
                    Button(action: {
                        service.purchaseProduct(identifier: product.productIdentifier)
                    }, label: {
                        Image(productId: product.productIdentifier)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .scaledToFit()
                            .clipShape(Circle())
                            .background(Circle())
                            .overlay(Circle().strokeBorder(.white, lineWidth: 4, antialiased: true))
                    })
                    .disabled(isEnabled)
                    Text(product.localizedTitle)
                        .foregroundColor(.primary)
                        .shadow(color: .blue, radius: 1, x: 1, y: 1)
                        .lineLimit(1)
                        .font(systemName: .Splatfont2, size: 20)
                })
                Text(isEnabled ? "購入済み" : product.localizedPrice ?? "-")
                    .frame(height: 14)
            })
        }
    }
}

struct SettingView_Product_Previews: PreviewProvider {
    static var previews: some View {
        ProductView()
            .preferredColorScheme(.dark)
            .environmentObject(StoreKitService())
    }
}

extension SKProduct: Identifiable {
    public var id: String { productIdentifier }
}
