//
//  CardWeaponDetail.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/06.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI
import SplatNet2

struct StatsWeaponDetail: View {
    let weaponData: WeaponStats
    
    var body: some View {
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.width / 90
            VStack(spacing: 0, content: {
                Image(weaponData.weaponType)
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .background(Circle().opacity(0.3))
                Text(String(format: "%0.3f%%", weaponData.suppliedProb * 100))
                    .font(systemName: .Splatfont2, size: 16 * scale)
            })
            .padding(.horizontal, 8)
            .overlay(Text("x\(weaponData.suppliedCount)")
                .font(systemName: .Splatfont2, size: 18 * scale, foregroundColor: .orange)
                .frame(height: 20)
                .padding(5), alignment: .topTrailing)
        })
        .scaledToFit()
    }
}
                       
struct StatsWave_Previews: PreviewProvider {
    static let weaponData = WeaponStats(data: (WeaponType.slosherVase, 10), total: 50)
    
    static var previews: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 100), spacing: 0), count: 4), spacing: 0, content: {
            StatsWeaponDetail(weaponData: weaponData)
            StatsWeaponDetail(weaponData: weaponData)
            StatsWeaponDetail(weaponData: weaponData)
            StatsWeaponDetail(weaponData: weaponData)
        })
        .previewLayout(.fixed(width: 400, height: 400))
        .preferredColorScheme(.dark)
    }
}
