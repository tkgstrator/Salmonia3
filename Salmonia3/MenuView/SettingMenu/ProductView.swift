//
//  ProductView.swift
//  Salmonia3
//
//  Created by Devonly on 3/25/21.
//

import SwiftUI

struct FreeProductView: View {
    @EnvironmentObject var free: CoreAppProduct

    var body: some View {
        Form {
            Toggle(isOn: $free.isFree01, label: {
                VStack(alignment: .leading, spacing: nil) {
                    Text(.FEATURE_FREE_01)
                    Text(.FEATURE_FREE_01_DESC)
                        .splatfont2(size: 12)
                }
            })
            Toggle(isOn: $free.isFree02, label: {
                VStack(alignment: .leading, spacing: nil) {
                    Text(.FEATURE_FREE_02)
                    Text(.FEATURE_FREE_02_DESC)
                        .splatfont2(size: 12)
                }
            })
            Toggle(isOn: $free.isFree03, label: {
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
    @EnvironmentObject var paid: CoreAppProduct
    @AppStorage("loadingIcon") var loadingIcon: LoadingType = .LOADING_SNOW

    var body: some View {
        Form {
            Section(header: EmptyView()) {
                Toggle(isOn: $paid.isPaid01, label: {
                    VStack(alignment: .leading, spacing: nil) {
                        Text(.FEATURE_PAID_01)
                        Text(.FEATURE_PAID_01_DESC)
                            .splatfont2(size: 12)
                    }
                })
                Toggle(isOn: $paid.isPaid02, label: {
                    VStack(alignment: .leading, spacing: nil) {
                        Text(.FEATURE_PAID_02)
                        Text(.FEATURE_PAID_02_DESC)
                            .splatfont2(size: 12)
                    }
                })
                Toggle(isOn: $paid.isPaid03, label: {
                    VStack(alignment: .leading, spacing: nil) {
                        Text(.FEATURE_PAID_03)
                        Text(.FEATURE_PAID_03_DESC)
                            .splatfont2(size: 12)
                    }
                })
            }
            Section(header: EmptyView()) {
                Picker(selection: $loadingIcon, label: Text(.SETTING_LOADING_TYPE) ) {
                    ForEach(LoadingType.allCases, id:\.rawValue) {
                        Text($0.rawValue.localized).tag($0)
                    }
                    .navigationTitle(.SETTING_LOADING_TYPE)
                }
            }
            .navigationTitle(.TITLE_PAID_PRODUCT)
        }
        .navigationTitle(.TITLE_PAID_PRODUCT)
        .onChange(of: loadingIcon) { value in
            loadingIcon = value
        }
        .splatfont2(size: 16)
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
