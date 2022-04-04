//
//  ResultDefeat.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/30.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftyUI
import RealmSwift

struct ResultDefeat: View {
    @State var isPresented: Bool = false
    let bossKillCount: [Int]
    
    init(bossKillCount: [Int]) {
        self.bossKillCount = bossKillCount
    }
    
    init(bossKillCount: RealmSwift.List<Int>) {
        self.bossKillCount = Array(bossKillCount)
    }
    
    var body: some View {
        let foregroundColor = Color(hex: "E5F100")
        GeometryReader(content: { geometry in
            Button(action: {
                isPresented.toggle()
            }, label: {
                Text("オオモノシャケをたおした数 x\(bossKillCount.reduce(0, +))")
                    .font(systemName: .Splatfont2, size: 11, foregroundColor: foregroundColor)
                    .shadow(color: .black, radius: 0, x: 1, y: 1)
            })
                .buttonStyle(.plain)
                .position(geometry.center)
        })
        .aspectRatio(172/12.5, contentMode: .fit)
    }
}

//struct ResultDefeat_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultDefeat()
//    }
//}
