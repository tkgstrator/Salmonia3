//
//  StatsWeapon.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/27.
//

import SwiftUI
import SwiftyUI
import SplatNet2

struct StatsWeaponList: View {
    let weaponType: WeaponType
    let count: Int
    let prob: Double
    
    init(weaponType: WeaponType, count: Int, prob: Double) {
        self.weaponType = weaponType
        self.count = count
        self.prob = prob
    }
    
    var textColor: Color {
        count == 0 ? .secondary : .primary
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            VStack(alignment: .leading, spacing: 0, content: {
                Image(weaponType)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35, alignment: .center)
                    .padding(4)
                VStack(alignment: .leading, spacing: -10, content: {
                    Text(String(format: "回数 %d", count))
                    Text(String(format: "確率 %.2f%%", prob * 100))
                })
            })
                .padding(4)
                .font(systemName: .Splatfont2, size: 12, foregroundColor: textColor)
        })
            .scaledToFit()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.whitesmoke))
            .grayscale(count == 0 ? 1.0 : 0.0)
    }
}

struct StatsWeaponList_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: nil, alignment: .center), count: 4), content: {
                ForEach(WeaponType.allCases) { weaponType in
                    StatsWeaponList(weaponType: weaponType, count: Int.random(in: 0 ... 5), prob: Double.random(in: 0 ... 1))
                }
            })
                .padding(.horizontal)
        })
            .previewDevice("iPhone 8")
            .preferredColorScheme(.dark)
            
    }
}
