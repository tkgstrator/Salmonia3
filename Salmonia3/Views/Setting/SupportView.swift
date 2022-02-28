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
    @EnvironmentObject var service: AppService
    
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
            Section(content: {
                ForEach(Array(service.products)) { product in
                    Button(action: {
                        
                    }, label: {
                        HStack(content: {
                            Text("アプリを応援する")
                            Spacer()
                            Text(product.localizedPrice!)
                        })
                    })
                }
            })
        })
            .navigationTitle("アプリを応援する")
    }
}

extension SKProduct: Identifiable {
    public var id: String { productIdentifier }
}

struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
        SupportView()
    }
}
