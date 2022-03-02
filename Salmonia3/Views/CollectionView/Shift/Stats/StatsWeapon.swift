//
//  StatsWeapon.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/01.
//

import SwiftUI
import SwiftyUI
import SplatNet2
import Surge

struct StatsWeapon: View {
    @State var scale: Double = .zero
    let weaponList: [WeaponType]
    let probs: [Double]
    
    init(weaponProbs: [StatsModel.WeaponProb]) {
        self.weaponList = weaponProbs.map({ $0.weaponType })
        self.probs = weaponProbs.map({ $0.prob })
    }
    
    let colors: [Color] = [.red, .blue, .green, .yellow]
    
    var body: some View {
        HStack(content: {
            VStack(spacing: 5, content: {
                ForEach(weaponList.indices) { index in
                    let weaponType: WeaponType = weaponList[index]
                    let prob: Double = probs[index]
                    let color: Color = colors[index]
                    HStack(spacing: 15, content: {
                        Image(weaponType)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30, alignment: .center)
                            .padding(4)
                            .background(Circle().fill(Color.black.opacity(0.9)))
                        Text(String(format:"%2.2f%%", prob * 100))
                            .font(systemName: .Splatfont2, size: 16, foregroundColor: color)
                        Spacer()
                    })
                        .frame(maxWidth: 155)
                }
            })
            Spacer()
            GeometryReader(content: { geometry in
                ForEach(probs.indices) { index in
                    let currentValue: Double = sum(probs.prefix(index))
                    let totalValue: Double = sum(probs.prefix(index + 1))
                    Circle()
                        .trim(from: currentValue, to: totalValue * scale)
                        .stroke(colors[index], lineWidth: 10)
                }
            })
                .aspectRatio(1.0, contentMode: .fit)
                .frame(maxHeight: 130)
                .rotationEffect(.degrees(-90))
        })
            .padding()
            .aspectRatio(16/9, contentMode: .fit)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.whitesmoke))
            .onAppear(perform: {
                withAnimation(.linear(duration: 1.5)) {
                    self.scale = 1.0
                }
            })
    }
}

struct StatsWeapon_Previews: PreviewProvider {
    static var previews: some View {
        StatsWeapon(weaponProbs: [])
            .preferredColorScheme(.dark)
    }
}
