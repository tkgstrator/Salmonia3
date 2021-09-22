//
//  StatsChartView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/07/24.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI

struct StatsChartView: View {
    @EnvironmentObject var stats: CoopShiftStats
    @State var isPresented: Bool = false
    var chartColors: [Color] = [.safetyorange, .easternblue, .dimgray, .blackrussian]
    
    /// スペシャルウェポンのチャートを表示
    var specialWeaponChart: some View {
        Group {
            Text("スペシャルウェポン")
                .splatfont2(.blackrussian, size: 18)
            HStack(alignment: .center, spacing: nil, content: {
                VStack(alignment: .center, spacing: 10, content: {
                    ForEach(stats.specials, id:\.self) { special in
                        HStack(alignment: .center, spacing: nil, content: {
                            Image(specialId: special.specialId)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 36, height: 36)
                                .mask(Circle())
                                .overlay(Circle().strokeBorder(Color.blackrussian, lineWidth: 1))
                            Text(special.prob)
                                .splatfont2(chartColors[stats.specials.firstIndex(of: special)!], size: 20)
                                .padding(.horizontal)
                                .frame(width: 100)
                        })
                    }
                })
                SpecialPieChartView(specials: stats.specials)
                    .aspectRatio(contentMode: .fit)
            })
        }
    }
    
    /// メインウェポンのチャートを表示
    var mainWeaponChart: some View {
        Group {
            Text("メインウェポン")
                .splatfont2(.blackrussian, size: 18)
            SuppliedWeaponView(isPresented: $isPresented, weapons: stats.weapons)
            .padding(.horizontal, 2)
        }
    }
    
    var randomWeaponChart: some View {
        Group {
            Text("支給されたブキ")
                .splatfont2(.blackrussian, size: 18)
            SuppliedWeaponView(isPresented: $isPresented, weapons: stats.weapons.filter({ $0.count > 0 }))
            Text("支給されていないブキ")
                .splatfont2(.blackrussian, size: 18)
            SuppliedWeaponView(isPresented: $isPresented, weapons: stats.weapons.filter({ $0.count == 0 }))
            .padding(.horizontal, 2)
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: nil, pinnedViews: [], content: {
                specialWeaponChart
                Image(ResultIcon.dot)
                switch stats.weapons.count == 4 {
                case true:
                    mainWeaponChart
                case false:
                    randomWeaponChart
                }
            })
        }
        .background(Color.seashell.edgesIgnoringSafeArea(.all))
    }
}

struct SuppliedWeaponView: View {
    @Binding var isPresented: Bool
    var weapons: [CoopShiftStats.ResultWeapon]
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 60, maximum: 120)), count: 4), alignment: .center, spacing: nil, pinnedViews: [], content: {
            ForEach(weapons, id:\.self) { weapon in
                Capsule().fill(weapon.count == 0 ? Color.gray.opacity(0.5) : Color.blackrussian).frame(width: 85, height: 36)
                    .overlay(
                        Image(weaponId: weapon.weaponId)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 36, height: 36)
                            .mask(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        ,
                        alignment: .leading
                    )
                    .overlay(
                        Text(isPresented ? weapon.prob : "\(weapon.count)")
                            .splatfont2(.seashell, size: 13)
                            .padding(.trailing, 8)
                            .frame(width: 85, alignment: .trailing)
                        ,
                        alignment: .leading
                    )
                    .onTapGesture {
                        isPresented.toggle()
                    }
            }
        })
    }
}
