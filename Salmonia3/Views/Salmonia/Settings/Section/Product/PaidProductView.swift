//
//  PaidProductView.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/18.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftyStoreKit
import StoreKit

struct PaidProductView: View {
    @State var products: [SKProduct] = []
    @State var skerror: SKError?
    @State var isPresented: Bool = false

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 140, maximum: 200)), count: 2), alignment: .center, spacing: nil, pinnedViews: [], content: {
                ForEach(products, id:\.self) { product in
                    VStack(alignment: .center, spacing: nil, content: {
                        Button(action: {
                            StoreKitManager.shared.purchaseItemFromAppStore(product: product.rawValue)
                        }, label: {
                            Circle().stroke(Color.primary, lineWidth: 3.0)
                                .frame(width: 70, height: 70)
                                .overlay(Image(systemName: product.rawValue.imageName).resizable().aspectRatio(contentMode: .fit).padding())
                        })
                        if product.rawValue.isEnabled {
                            Text(.TEXT_PURCHASED)
                                .splatfont2(size: 14)
                        } else {
                            HStack(content: {
                                Text(product.localizedTitle)
                                Text(product.localizedPrice ?? "-")
                            })
                            .splatfont2(size: 14)
                        }
                        Text(product.localizedDescription)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                        .splatfont2(size: 12)
                        Spacer()
                    })
                    .padding()
                }
                restoreButton
                #if DEBUG
                lockButton
                #endif
            })
        }
        .splatfont2(size: 16)
        .onAppear {
            StoreKitManager.shared.retreiveProductInfo(productIds: StoreKitManager.StoreItem.allCases) { product in
                products = Array(product).sorted(by: { $0.productIdentifier > $1.productIdentifier })
            }
        }
        .navigationTitle(.TITLE_PAID_PRODUCT)
    }

    var restoreButton: some View {
        VStack(alignment: .center, spacing: nil, content: {
            Button(action: {
                StoreKitManager.shared.restorePurchases() { completion in
                    switch completion {
                    case .success:
                        break
                    case .failure(let error):
                        skerror = error
                    }
                }
            }, label: {
                Circle().stroke(Color.primary, lineWidth: 3.0)
                    .frame(width: 70, height: 70)
                    .overlay(Image(systemName: "icloud.and.arrow.down").resizable().aspectRatio(contentMode: .fit).padding())
            })
            Text(.RESTORE)
                .splatfont2(size: 14)
            Text(.FEATURE_RESTORE_DESC)
                .splatfont2(size: 12)
        })
        .alert(item: $skerror) { skerror in
            Alert(title: Text(.ALERT_ERROR), message: Text(skerror.localizedDescription))
        }
        .alert(isPresented: $isPresented, content: {
            Alert(title: Text(.RESTORE), message: Text(.RESTORE_MESSAGE))
        })
    }
    
    var lockButton: some View {
        Button(action: {
            StoreKitManager.shared.lockPurchasedItes()
        }, label: {
            Circle().stroke(Color.primary, lineWidth: 3.0)
                .frame(width: 70, height: 70)
                .overlay(Image(systemName: "lock").resizable().aspectRatio(contentMode: .fit).padding())
        })
    }
}

struct PaidProductView_Previews: PreviewProvider {
    static var previews: some View {
        PaidProductView()
    }
}
