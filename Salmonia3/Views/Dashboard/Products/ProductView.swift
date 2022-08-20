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
import Combine

struct ProductView: View {
    @EnvironmentObject var service: StoreKitService

    var body: some View {
        let columnCounts: Int = UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2
        ScrollView(.vertical, showsIndicators: false, content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 200), spacing: 0, alignment: .top), count: columnCounts), spacing: 0, content: {
                ForEach(service.retrieveProducts) { product in
                    ProductItem(product: product)
                }
                RestoreItem()
                #if DEBUG
                DerestoreItem()
                #endif
            })
        })
        .navigationTitle("追加機能")
        .navigationBarTitleDisplayMode(.inline)
        .environmentObject(LoadingService())
        .font(systemName: .Splatfont2, size: 16)
    }
}

extension ProductView {

    struct DerestoreItem: View {
        @EnvironmentObject var service: StoreKitService
        @State private var isPresented: Bool = false
        @State private var cancellable: AnyCancellable?

        var body: some View {
            GeometryReader(content: { geometry in
                VStack(content: {
                    let scale: CGFloat = geometry.width / 180
                    let width: CGFloat = geometry.width / 180 * 100
                    Button(action: {
                        service.deactivateNonConsumableContents()
                    }, label: {
                        Image(StickersType.lijudd)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .background(Circle())
                            .frame(width: width, height: width)
                    })
                    .font(systemName: .Splatfont2, size: 16 * scale)
                    .overlay(Circle().strokeBorder(lineWidth: 4, antialiased: true))
                    Text("無効化")
                        .foregroundColor(.primary)
                        .font(systemName: .Splatfont2, size: 16 * scale)
                        .frame(height: 16 * scale)
                    Text("コンテンツを無効化")
                        .foregroundColor(.primary)
                        .font(systemName: .Splatfont2, size: 14 * scale)
                        .frame(height: 14 * scale)
                })
                .position(geometry.center)
            })
            .scaledToFit()
            .alert("復元", isPresented: $isPresented){
                Button("了解", role: nil) {
                }
            } message: {
                Text("購入履歴を初期化しました")
            }
        }
    }

    struct RestoreItem: View {
        @EnvironmentObject var service: StoreKitService
        @State private var isPresented: Bool = false
        @State private var cancellable: AnyCancellable?

        var body: some View {
            GeometryReader(content: { geometry in
                VStack(content: {
                    let scale: CGFloat = geometry.width / 180
                    let width: CGFloat = geometry.width / 180 * 100
                    Button(action: {
                        cancellable = service.restorePurchasedProducts()
                            .sink(receiveValue: { result in
                                isPresented = result
                            })
                    }, label: {
                        Image(StickersType.lijudd)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .background(Circle())
                            .frame(width: width, height: width)
                    })
                    .font(systemName: .Splatfont2, size: 16 * scale)
                    .overlay(Circle().strokeBorder(lineWidth: 4, antialiased: true))
                    Text("復元")
                        .foregroundColor(.primary)
                        .font(systemName: .Splatfont2, size: 16 * scale)
                        .frame(height: 16 * scale)
                    Text("コンテンツを再有効化")
                        .foregroundColor(.primary)
                        .font(systemName: .Splatfont2, size: 14 * scale)
                        .frame(height: 14 * scale)
                })
                .position(geometry.center)
            })
            .scaledToFit()
            .alert("復元", isPresented: $isPresented){
                Button("了解", role: nil) {
                }
            } message: {
                Text("購入済みのコンテンツを復元しました")
            }
        }
    }

    struct ProductItem: View {
        @EnvironmentObject var service: StoreKitService
        var isEnabled: Bool {
            UserDefaults.standard.bool(forKey: product.productIdentifier)
        }
        let product: SKProduct

        var body: some View {
            let localizedPrice: String = "\(product.localizedSubscriptionPeriod) \(product.localizedPrice ?? "-")"
            GeometryReader(content: { geometry in
                VStack(content: {
                    let scale: CGFloat = geometry.width / 180
                    let width: CGFloat = geometry.width / 180 * 100
                    Button(action: {
                        service.purchaseProduct(identifier: product.productIdentifier)
                    }, label: {
                        Image(productId: product.productIdentifier)
                            .resizable()
                            .clipShape(Circle())
                            .background(Circle())
                            .frame(width: width, height: width)
                            .scaledToFit()
                    })
                    .disabled(isEnabled)
                    .font(systemName: .Splatfont2, size: 16 * scale)
                    .overlay(Circle().strokeBorder(lineWidth: 4, antialiased: true))
                    Text(product.localizedTitle)
                        .foregroundColor(.primary)
                        .font(systemName: .Splatfont2, size: 16 * scale)
                        .frame(height: 16 * scale)
                    Text(isEnabled ? "購入済み" : localizedPrice)
                        .foregroundColor(.primary)
                        .font(systemName: .Splatfont2, size: 14 * scale)
                        .frame(height: 14 * scale)
                })
                .position(geometry.center)
            })
            .scaledToFit()
        }
    }
}

struct SettingView_Product_Previews: PreviewProvider {
    static var previews: some View {
        ProductView()
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 300, height: 400))
            .environmentObject(StoreKitService())
    }
}

extension SKProduct: Identifiable {
    public var id: String { productIdentifier }
}
