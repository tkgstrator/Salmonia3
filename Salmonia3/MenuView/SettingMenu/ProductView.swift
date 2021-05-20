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
        List {
            Toggle(isOn: $free.isFree01, label: {
                VStack(alignment: .leading, spacing: nil) {
                    Text("FEATURE_FREE_01")
                    Text("FEATURE_FREE_01_DESC")
                        .splatfont2(size: 12)
                }
            })
            Toggle(isOn: $free.isFree02, label: {
                VStack(alignment: .leading, spacing: nil) {
                    Text("FEATURE_FREE_02")
                    Text("FEATURE_FREE_02_DESC")
                        .splatfont2(size: 12)
                }
            })
            Toggle(isOn: $free.isFree03, label: {
                VStack(alignment: .leading, spacing: nil) {
                    Text("FEATURE_FREE_03")
                    Text("FEATURE_FREE_03_DESC")
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
    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 60, maximum: 80)), count: 3), alignment: .center, spacing: 10, pinnedViews: []) {
            ForEach(Range(0...11)) { number in
                Button(action: {}, label: {
                    Text("\(number)")
                        .frame(width: 60, height: 60, alignment: .center)
                })
//                .buttonStyle(CircleButtonStyle())
            }
        }
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        FreeProductView()
    }
}
