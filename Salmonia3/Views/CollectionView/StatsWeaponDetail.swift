//
//  CardWeaponDetail.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/06.
//

import Foundation
import SwiftUI
import SplatNet2

struct StatsWeaponDetail: View {
    let weaponData: WeaponStats
    
    var body: some View {
        GeometryReader(content: { geometry in
            VStack(alignment: .leading, spacing: -6, content: {
                Image(weaponData.weaponType)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45, alignment: .center)
                Spacer()
                Group(content: {
                    HStack(content: {
                        Text("支給回数")
                        Spacer()
                        Text("\(weaponData.suppliedCount)回")
                    })
                    HStack(content: {
                        Text("支給率")
                        Spacer()
                        Text(String(format: "%5.2f%%", weaponData.suppliedProb * 100))
                    })
                })
                    .padding(.horizontal, 4)
                    .font(systemName: .Splatfont2, size: 10)
            })
        })
            .padding(4)
            .scaledToFit()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.whitesmoke))
    }
}
                       
struct StatsWave_Previews: PreviewProvider {
    static let weaponData = WeaponStats(data: (WeaponType.slosherVase, 10), total: 50)
    
    static var previews: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), content: {
            StatsWeaponDetail(weaponData: weaponData)
        })
            .preferredColorScheme(.dark)
    }
}
