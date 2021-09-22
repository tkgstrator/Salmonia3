//
//  UserView.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/22.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftyUI
import SDWebImageSwiftUI

struct UserView: View {
    @EnvironmentObject var results: CoreRealmCoop
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            HStack(alignment: .center, spacing: nil, content: {
                WebImage(url: manager.account.imageUri)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                Text(manager.account.nickname)
                    .font(.custom("Splatfont2", size: 20))
            })
        })
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
