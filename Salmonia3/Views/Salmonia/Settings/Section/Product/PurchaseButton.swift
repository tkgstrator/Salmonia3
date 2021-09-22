//
//  ProductView.swift
//  Salmonia3
//
//  Created by tkgstrator on 3/25/21.
//

import SwiftUI
import SwiftyStoreKit
import StoreKit
import SwiftyUI

struct PurchaseButton: View {
    let product: SKProduct
    
    var disableButton: some View {
        Image(systemName: "eye.slash")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 60, height: 60, alignment: .center)
            .padding()
            .overlay(Circle().stroke(Color.primary, lineWidth: 3.0))
            .overlay(Text(product.isPurchased ? "PURCHASED".localized : product.localizedPrice ?? "-")
                        .padding(.horizontal)
                        .background(RoundedRectangle(cornerRadius: .infinity)
                                        .fill(product.isPurchased ? Color.blue : Color.red))
                        .offset(x: 60, y: -40)
            )
    }
    
    var multipleButton: some View {
        Image(systemName: "person.3")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 60, height: 60, alignment: .center)
            .padding()
            .overlay(Circle().stroke(Color.primary, lineWidth: 3.0))
            .overlay(Text(product.isPurchased ? "PURCHASED".localized : product.localizedPrice ?? "-")
                        .padding(.horizontal)
                        .background(RoundedRectangle(cornerRadius: .infinity)
                                        .fill(product.isPurchased ? Color.blue : Color.red))
                        .offset(x: 60, y: -40)
            )
    }
    
    var lotteryButton: some View {
        Image(systemName: "giftcard")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 60, height: 60, alignment: .center)
            .padding()
            .overlay(Circle().stroke(Color.primary, lineWidth: 3.0))
            .overlay(Text(product.isPurchased ? "PURCHASED".localized : product.localizedPrice ?? "-")
                        .padding(.horizontal)
                        .background(RoundedRectangle(cornerRadius: .infinity)
                                        .fill(product.isPurchased ? Color.blue : Color.red))
                        .offset(x: 60, y: -40)
            )
    }
    
    var body: some View {
        VStack {
            Button(action: {
                StoreKitManager.shared.purchaseItemFromAppStore(productId: product.productIdentifier)
            }, label: {
                switch StoreKitManager.StoreItem(rawValue: product.productIdentifier)! {
                case .disableads:
                    disableButton
                case .multiaccounts:
                    multipleButton
                case .lottery:
                    lotteryButton
                }
            })
            .disabled(product.isPurchased)
            Text(product.localizedTitle)
                .splatfont2(.primary, size: 18)
        }
        .padding()
    }
}
