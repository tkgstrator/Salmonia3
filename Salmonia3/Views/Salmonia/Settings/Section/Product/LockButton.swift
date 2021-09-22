//
//  LockButton.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/18.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI

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

struct LockButton_Previews: PreviewProvider {
    static var previews: some View {
        LockButton()
    }
}
