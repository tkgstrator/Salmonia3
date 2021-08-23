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

enum LoadingType: String, CaseIterable {
    case LOADING_IKA    = "LoadingIka"
    case LOADING_SPIN   = "LoadingSpin"
    case LOADING_SNOW   = "LoadingSnow"
}

struct PaidProductView_Previews: PreviewProvider {
    static var previews: some View {
        PaidProductView()
            .environmentObject(AppManager())
    }
}

struct RestoreButton: View {
    @State var skerror: SKError?
    @State var isPresented: Bool = false
    
    var body: some View {
        VStack {
            Button(action: {
                StoreKitManager.shared.restorePurchases() { completion in
                    switch completion {
                    case .success:
                        skerror = nil
                        isPresented.toggle()
                    case .failure(let error):
                        skerror = error
                        isPresented.toggle()
                    }
                }
            }, label: {
                Image(systemName: "icloud.and.arrow.down")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60, alignment: .center)
                    .padding()
                    .overlay(Circle().stroke(Color.primary, lineWidth: 3.0))
                    .overlay(Text(.RESTORE)
                                .padding(.horizontal)
                                .background(RoundedRectangle(cornerRadius: .infinity)
                                                .fill(Color.red))
                                .offset(x: 60, y: -40)
                    )
            })
            Text(.FEATURE_RESTORE_DESC)
        }
        .alert(isPresented: $isPresented) {
            if let error = skerror {
                return Alert(title: Text(.ALERT_ERROR), message: Text(error.localizedDescription))
            } else {
                return Alert(title: Text(.RESTORE), message: Text(.RESTORE_MESSAGE))
            }
        }
    }
}

struct LockButton: View {
    var body: some View {
        VStack {
            Button(action: {
                StoreKitManager.shared.lockPurchasedItes()
            }, label: {
                Image(systemName: "lock")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60, alignment: .center)
                    .padding()
                    .overlay(Circle().stroke(Color.primary, lineWidth: 3.0))
                    .overlay(Text(.RESET)
                                .padding(.horizontal)
                                .background(RoundedRectangle(cornerRadius: .infinity)
                                                .fill(Color.red))
                                .offset(x: 60, y: -40)
                    )
            })
            Text(.FEATURE_RESET_DESC)
        }
    }
}

struct PurchaseButton: View {
    let product: SKProduct

    var body: some View {
        VStack {
            Button(action: {
                StoreKitManager.shared.purchaseItemFromAppStore(productId: product.productIdentifier)
            }, label: {
                switch StoreKitManager.StoreItem(rawValue: product.productIdentifier)! {
                case .disableads:
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
                case .multiaccounts:
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
                case .lottery:
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
                default:
                    EmptyView()
                }
            })
            .disabled(product.isPurchased)
            Text(product.localizedTitle)
                .splatfont2(.primary, size: 18)
//            Text(product.localizedDescription)
//                .splatfont2(.primary, size: 16)
//                .frame(height: 60)
//                .lineLimit(2)
//                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
