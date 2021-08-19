//
//  ProductView.swift
//  Salmonia3
//
//  Created by Devonly on 3/25/21.
//

import SwiftUI
import SwiftyStoreKit
import StoreKit

struct FreeProductView: View {
    @EnvironmentObject var appManager: AppManager

    var body: some View {
        List {
            Toggle(isOn: $appManager.isFree01, label: {
                VStack(alignment: .leading, spacing: nil) {
                    Text(.FEATURE_FREE_01)
                    Text(.FEATURE_FREE_01_DESC)
                        .splatfont2(size: 12)
                }
            })
            Toggle(isOn: $appManager.isFree02, label: {
                VStack(alignment: .leading, spacing: nil) {
                    Text(.FEATURE_FREE_02)
                    Text(.FEATURE_FREE_02_DESC)
                        .splatfont2(size: 12)
                }
            })
            Toggle(isOn: $appManager.isFree03, label: {
                VStack(alignment: .leading, spacing: nil) {
                    Text(.FEATURE_FREE_03)
                    Text(.FEATURE_FREE_03_DESC)
                        .splatfont2(size: 12)
                }
            })
        }
        .navigationTitle(.TITLE_FREE_PRODUCT)
        .splatfont2(size: 16)
    }
}

struct FreeProductItem: ProductItemProtocol {
    var id: String = UUID().uuidString
    var title: String
    var description: String
    var price: Int?
}

protocol ProductItemProtocol: Identifiable {
    var id: String { get }
    var title: String { get }
    var description: String { get }
    var price: Int? { get }
}

struct PaidProductView: View {
    @EnvironmentObject var appManager: AppManager
    @AppStorage("loadingIcon") var loadingIcon: LoadingType = .LOADING_SNOW
    @State var allAvailableItems: [SKProduct] = []
    
    var body: some View {
        List {
            Section(header: Text("Paid").splatfont2(.orange, size: 14)) {
                ForEach(allAvailableItems, id:\.self) { item in
                    HStack {
                        VStack(alignment: .leading, spacing: nil) {
                            Text(item.productIdentifier)
                                .splatfont2(size: 12)
                            Text("\(item.localizedPrice ?? "-")")
                        }
                        Spacer()
                        Button(action: { StoreKitManager.shared.purchaseItemFromAppStore(productId: item.productIdentifier) }, label: {
                            Text("\(item.isPurchased ? "PURCHASED" : "PURCHASE")")
                        })
                    }
                }
            }
            Section(header: Text("Restore").splatfont2(.orange, size: 14)) {
                Button(action: { StoreKitManager.shared.restorePurchases() }, label: {
                    Text("Restore")
                })
            }
            #if DEBUG
            Section(header: Text("Lock").splatfont2(.orange, size: 14)) {
                Button(action: { StoreKitManager.shared.lockPurchasedItes() }, label: {
                    Text("Lock")
                })
            }
            #endif
        }
        .navigationTitle(.TITLE_PAID_PRODUCT)
        .splatfont2(size: 16)
        .onAppear(perform: getAllAvailableItems)
    }
    
    func getAllAvailableItems() {
        StoreKitManager.shared.retreiveProductInfo(productIds: StoreKitManager.StoreItem.allCases) { [self] products in
            allAvailableItems = Array(products)
        }
    }
}

enum LoadingType: String, CaseIterable {
    case LOADING_IKA    = "LoadingIka"
    case LOADING_SPIN   = "LoadingSpin"
    case LOADING_SNOW   = "LoadingSnow"
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        FreeProductView()
    }
}
