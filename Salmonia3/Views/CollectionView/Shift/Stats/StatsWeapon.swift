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
    let shiftType: ShiftType
    
    enum ShiftType: CaseIterable {
        case normal
        case oneRandom
        case allRandom
        case goldRandom
    }
    
    init(weaponProbs: [StatsModel.WeaponProb]) {
        self.weaponList = weaponProbs.map({ $0.weaponType })
        self.probs = weaponProbs.map({ $0.prob })
        self.shiftType = {
            if weaponProbs.allSatisfy({ $0.weaponType == .randomGreen }) {
                return .allRandom
            }
            if weaponProbs.allSatisfy({ $0.weaponType == .randomGold }) {
                return .goldRandom
            }
            if weaponProbs.contains(where: { $0.weaponType == .randomGreen }) {
                return .oneRandom
            }
            return .normal
        }()
    }
    
    let colors: [Color] = [.red, .blue, .green, .yellow]
    
    var body: some View {
        HStack(content: {
            VStack(spacing: 5, content: {
                ForEach(weaponList.indices, id: \.self) { index in
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
                        switch shiftType {
                        case .normal, .goldRandom:
                            Text(String(format:"%05.2f%%", prob * 100))
                                .font(systemName: .Splatfont2, size: 16, foregroundColor: color)
                        case .oneRandom, .allRandom:
                            Text("??.??%")
                                .font(systemName: .Splatfont2, size: 16, foregroundColor: color)
                        }
                        Spacer()
                    })
                        .frame(maxWidth: 155)
                }
            })
            Spacer()
            GeometryReader(content: { geometry in
                ZStack(alignment: .center, content: {
                    ForEach(probs.indices) { index in
                        let currentValue: Double = sum(probs.prefix(index))
                        let totalValue: Double = sum(probs.prefix(index + 1))
                        Circle()
                            .trim(from: currentValue, to: totalValue * scale)
                            .stroke(colors[index], lineWidth: 10)
                            .rotationEffect(.degrees(-90))
                    }
                    if (shiftType == .allRandom) || (shiftType == .oneRandom) {
                        Text("詳細データ閲覧")
                            .underline()
                            .font(systemName: .Splatfont2, size: 16, foregroundColor: .primary)
                    }
                })
            })
                .aspectRatio(1.0, contentMode: .fit)
                .frame(maxHeight: 130)
        })
            .padding()
            .aspectRatio(16/9, contentMode: .fit)
            .background(RoundedRectangle(cornerRadius: 6).fill(Color.whitesmoke))
            .onAppear(perform: {
                withAnimation(.linear(duration: 1.5)) {
                    self.scale = 1.0
                }
            })
    }
}

struct StatsWeapon_Previews: PreviewProvider {
//    static var weaponProbs: [StatsModel.WeaponProb] = [
//        StatsModel.WeaponProb(weaponType: .shooterBlasterBurst, prob: 0.25),
//        StatsModel.WeaponProb(weaponType: .umbrellaAutoAssault, prob: 0.25),
//        StatsModel.WeaponProb(weaponType: .chargerSpark, prob: 0.25),
//        StatsModel.WeaponProb(weaponType: .slosherVase, prob: 0.25)
//    ]
    
    static var weaponProbs: [StatsModel.WeaponProb] = [
        StatsModel.WeaponProb(weaponType: .randomGreen, prob: 0.25),
        StatsModel.WeaponProb(weaponType: .randomGreen, prob: 0.25),
        StatsModel.WeaponProb(weaponType: .randomGreen, prob: 0.25),
        StatsModel.WeaponProb(weaponType: .randomGreen, prob: 0.25)
    ]
    static var previews: some View {
        StatsWeapon(weaponProbs: weaponProbs)
            .preferredColorScheme(.dark)
    }
}
