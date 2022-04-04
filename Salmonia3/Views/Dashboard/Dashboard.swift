//
//  Dashboard.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/31.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI

enum Dashboard {}

extension Dashboard {
    struct Top: View {
        var body: some View {
            ScrollView(.vertical, showsIndicators: false, content: {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            })
        }
    }
}

struct DashboardTOP_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard.Top()
    }
}
