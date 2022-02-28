//
//  SupportView.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/01.
//

import SwiftUI
import SwiftyUI
import StoreKit

struct SupportView: View {
    var body: some View {
        Form(content: {
            Button(action: {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }, label: {
                HStack(content: {
                    Image(systemName: .PencilAndOutline)
                    Spacer()
                    Text("レビューする")
                })
            })
        })
            .navigationTitle("アプリを応援する")
    }
}

struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
        SupportView()
    }
}
