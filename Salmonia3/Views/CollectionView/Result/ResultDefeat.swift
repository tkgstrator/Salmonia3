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
        Button(action: {
            isPresented.toggle()
        }, label: {
            Text("オオモノシャケをたおした数 x\(bossKillCount.reduce(0, +))")
                .font(systemName: .Splatfont2, size: 14, foregroundColor: .yellow)
                .shadow(color: .black, radius: 0, x: 1.2, y: 0.5)
        })
            .buttonStyle(.plain)
    }
}

//struct ResultDefeat_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultDefeat()
//    }
//}
