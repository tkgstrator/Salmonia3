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
                PieChartView(specials: stats.specials)
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
            ForEach(weapons.filter({ $0.count > 0 }), id:\.self) { weapon in
                Capsule().fill(Color.blackrussian).frame(width: 85, height: 36)
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

struct PieChartView: View {
    let chartColors: [Color] = [.safetyorange, .easternblue, .dimgray, .blackrussian]
    let specials: [CoopShiftStats.ResultSpecial]
    let jobNum: Int
    let angles: [AnglePair]

    init(specials: [CoopShiftStats.ResultSpecial]) {
        self.specials = specials
        self.jobNum = specials.map({ $0.count }).reduce(0, +)
        self.angles = specials.anglePairs
    }
    
    var body: some View {
        Circle()
            .strokeBorder(Color.blackrussian, lineWidth: 3)
            .frame(width: 200, height: 200)
            .background(cirlceLayer)
            .overlay(Circle()
                        .fill(Color.blackrussian)
                        .frame(width: 124, height: 124))
            .overlay(
                VStack(alignment: .center, spacing: -20, content: {
                    Text("今回のバイト回数")
                    Text("\(jobNum)回")
                })
                .splatfont2(.seashell, size: 20)
            )
    }
    
    var cirlceLayer: some View {
        ZStack(alignment: .center, content: {
            ForEach(angles, id:\.self) { angle in
                Pie(startAngle: angle.startAngle, endAngle: angle.endAngle)
                    .fill(chartColors[angles.firstIndex(of: angle)!])
            }
            ForEach(angles, id:\.self) { angle in
                Image(specialId: angle.specialId)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 36, height: 36)
                    .offset(x: 80 * cos(angle.offsetAngle), y: 80 * sin(angle.offsetAngle))
            }
        })
    }
}

struct AnglePair: Hashable {
    let specialId: Int
    let startAngle: Angle
    let endAngle: Angle
    let offsetAngle: CGFloat
    
    internal init(specialId: Int, startAngle: Angle, endAngle: Angle, offsetAngle: CGFloat) {
        self.specialId = specialId
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.offsetAngle = offsetAngle
    }
}

struct Pie: Shape {
    let startAngle: Angle
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = min(center.x, center.y)
        let path = Path { path in
            path.addArc(center: center,
                        radius: radius,
                        startAngle: startAngle,
                        endAngle: endAngle,
                        clockwise: false)
            path.addLine(to: center)
        }
        return path
    }
}

fileprivate extension Array where Element == CoopShiftStats.ResultSpecial {
    var anglePairs: [AnglePair] {
        let totalValue: Int = self.map({ $0.count }).reduce(0, +)
        var startAngle: Angle = .degrees(-90)
        var angles: [AnglePair] = []
        
        for special in self {
            let value = special.count
            if value >= 1 {
                let endAngle = startAngle + .degrees(360 * CGFloat(value) / CGFloat(totalValue))
                let offsetAngle = CGFloat(((startAngle + endAngle) / 2).degrees / 180 * .pi)
                angles.append(AnglePair(specialId: special.specialId, startAngle: startAngle, endAngle: endAngle, offsetAngle: offsetAngle))
                startAngle = endAngle
            }
        }
        return angles
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        StatsChartView()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 8")
    }
}
