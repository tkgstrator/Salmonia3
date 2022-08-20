//
//  ResultWave.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/30.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftyUI
import SplatNet2

struct ResultWaveView: View {
    let result: RealmCoopResult
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 100, maximum: 120), alignment: .top), count: 3), content: {
            ForEach(result.wave) { wave in
                ResultWave(wave: wave)
            }
        })
    }
}

private struct ResultWaveWater: View {
    let waterLevel: WaterKey
    let foregroundColor = Color(hex: "E5F100")
    
    var body: some View {
        ZStack(alignment: .bottom, content: {
            Wavecard()
                .fill(foregroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 3))
            Water()
                .fill(.black.opacity(0.2))
                .offset(x: 0, y: 152 - waterLevel.height)
                .clipShape(RoundedRectangle(cornerRadius: 3))
        })
    }
}

private struct WaveClearChecker: View {
    let isClear: Bool
    let clearColor = Color(hex: "39E464")
    let failureColor = Color(hex: "FF7500")

    var body: some View {
        GeometryReader(content: { geometry in
            SplatInk()
                .fill(Color.black)
                .overlay(Text(isClear ? "GJ!" : "NG").font(systemName: .Splatfont2, size: 14, foregroundColor: isClear ? clearColor : failureColor).padding(.top, 4))
                .frame(width: 43, height: 46, alignment: .center)
                .position(x: geometry.width - 6, y: 0)
        })
    }
}

private struct ResultWave: View {
    let wave: RealmCoopWave
    let backgroundColor = Color(hex: "2A270B")

    var body: some View {
        VStack(spacing: 0, content: {
            GeometryReader(content: { geometry in
                VStack(alignment: .center, spacing: 0, content: {
                    Text("Wave \(wave.index)")
                        .font(systemName: .Splatfont2, size: 17, foregroundColor: .black)
                        .frame(height: 25, alignment: .center)
                    ZStack(content: {
                        Rectangle().fill(backgroundColor)
                        Text(String(format: "%2d/%2d", wave.goldenIkuraNum, wave.quotaNum))
                            .font(systemName: .Splatfont2, size: 25, foregroundColor: .white)
                            .frame(height: 36.5, alignment: .center)
                    })
                    .padding(.top, 2)
                    .frame(height: 36.5, alignment: .center)
                    Text(wave.waterLevel)
                        .font(systemName: .Splatfont2, size: 14, foregroundColor: .black)
                        .padding(.top, 8)
                    Text(wave.eventType)
                        .font(systemName: .Splatfont2, size: 14, foregroundColor: .black)
                })
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                WaveClearChecker(isClear: wave.isClear)
            })
            .aspectRatio(124/152, contentMode: .fit)
            .background(ResultWaveWater(waterLevel: wave.waterLevel))
            HStack(spacing: 4, content: {
                Image(.golden)
                    .resizable()
                    .frame(width: 15, height: 15, alignment: .center)
                Text("出現数 x\(wave.goldenIkuraPopNum)")
                    .font(systemName: .Splatfont2, size: 12, foregroundColor: .white)
                    .shadow(color: .black, radius: 0, x: 1, y: 1)
            })
            HStack(spacing: 4, content: {
                Image(.power)
                    .resizable()
                    .frame(width: 15, height: 15, alignment: .center)
                Text("獲得数 x\(wave.ikuraNum)")
                    .font(systemName: .Splatfont2, size: 12, foregroundColor: .white)
                    .shadow(color: .black, radius: 0, x: 1, y: 1)
            })
            LazyVGrid(columns: Array(repeating: .init(.fixed(22), spacing: 3), count: 5), spacing: 3, content: {
                ForEach(wave.specialUsage.indices, id: \.self) { index in
                    let specialId = wave.specialUsage[index]
                    Image(specialId)
                        .resizable()
                        .frame(width: 22, height: 22, alignment: .center)
                        .background(Circle().fill(.black))
                }
            })
        })
        .rotationEffect(.degrees(-2))
    }
}

struct ResultWave_Previews: PreviewProvider {
    static var previews: some View {
        ResultWaveView(result: RealmCoopResult(dummy: true))
            .previewLayout(.fixed(width: 400, height: 200))
    }
}

extension Text {
    init(_ waterLevel: WaterKey) {
        self.init(waterLevel.waterLevel)
    }
    
    init(_ eventType: EventKey) {
        self.init(eventType.eventType)
    }
}

fileprivate extension WaterKey {
    var waterLevel: String {
        switch self {
        case .high:
            return "満潮"
        case .low:
            return "干潮"
        case .normal:
            return "通常"
        }
    }
}

fileprivate extension EventKey {
    var eventType: String {
        switch self {
        case .waterLevels:
            return "-"
        case .rush:
            return "ラッシュ"
        case .goldieSeeking:
            return "キンシャケ探し"
        case .griller:
            return "グリル発進"
        case .fog:
            return "霧"
        case .theMothership:
            return "ハコビヤ襲来"
        case .cohockCharge:
            return "ドスコイ大量発生"
        }
    }
}

fileprivate extension WaterKey {
    var height: CGFloat {
        switch self {
        case .low:
            return 20
        case .normal:
            return 40
        case .high:
            return 70
        }
    }
}
