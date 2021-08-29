//
//  StatsWeaponView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/05/15.
//

import Foundation
import SwiftUI

struct StatsWeaponView: View {
    typealias WeaponList = CoopShiftStats.ResultWeapon
    @ObservedObject var stats: CoopShiftStats
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: min(5, stats.weaponData.count)), alignment: .center, spacing: nil, pinnedViews: []) {
                ForEach(stats.weaponData) { weapon in
                    ZStack(alignment: .bottomLeading) {
                        if weapon.count == 0 {
                            Image(weapon.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50)
                                .grayscale(0.99)
                                .opacity(0.5)
                                .padding(.all, 5)
                        } else {
                            Image(weapon.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50)
                                .padding(.all, 5)
                        }
                        Circle().fill(Color.white).frame(width: 25, height: 25)
                            .overlay(Text("\(weapon.count)")).foregroundColor(.black)
                            .splatfont2(.black, size: 14)
                    }
                }
            }
            .padding(.bottom, 20)
        }
    }
}
