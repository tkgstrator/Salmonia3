//
//  RestoreButton.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/18.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI

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

struct RestoreButton_Previews: PreviewProvider {
    static var previews: some View {
        RestoreButton()
    }
}
