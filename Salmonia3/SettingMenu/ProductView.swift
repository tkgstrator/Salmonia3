//
//  ProductView.swift
//  Salmonia3
//
//  Created by Devonly on 3/25/21.
//

import SwiftUI

struct FreeProductView: View {
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



//struct ProductView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductView()
//    }
//}
