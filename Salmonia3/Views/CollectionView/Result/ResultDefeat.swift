//
//  ResultDefeat.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/30.
//

import SwiftUI
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
        GeometryReader(content: { geometry in
            Button(action: {
                isPresented.toggle()
            }, label: {
                Text("オオモノシャケをたおした数 x\(bossKillCount.reduce(0, +))")
                    .font(systemName: .Splatfont2, size: 11, foregroundColor: .yellow)
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
