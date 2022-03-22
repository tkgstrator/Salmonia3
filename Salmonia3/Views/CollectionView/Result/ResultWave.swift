//
//  ResultWave.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/30.
//

import SwiftUI
import SplatNet2

struct ResultWaveView: View {
    let result: RealmCoopResult
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 120), alignment: .top), count: result.wave.count), content: {
            ForEach(result.wave) { wave in
                VStack(alignment: .center, spacing: 0, content: {
                    Text("WAVE \(wave.index)")
                        .font(systemName: .Splatfont2, size: 14)
                        .foregroundColor(.black)
                        .lineLimit(1)
                    Text("\(wave.goldenIkuraNum)/\(wave.quotaNum)")
                        .font(systemName: .Splatfont2, size: 22)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                    VStack(spacing: -10, content: {
                        Text("\(wave.ikuraNum)")
                            .font(systemName: .Splatfont2, size: 16)
                            .foregroundColor(.red)
                        Text(wave.waterLevel)
                            .font(systemName: .Splatfont2, size: 14)
                            .minimumScaleFactor(1.0)
                            .foregroundColor(.black)
                        Text(wave.eventType)
                            .font(systemName: .Splatfont2, size: 14)
                            .minimumScaleFactor(1.0)
                            .foregroundColor(.black)
                    })
                })
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.yellow))
            }
        })
            .padding(.horizontal)
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
