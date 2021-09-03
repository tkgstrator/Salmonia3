//
//  CoopPlayerResultView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/05/10.
//

import SwiftUI
import RealmSwift
import URLImage

struct CoopPlayerResultView: View {
    @AppStorage("FEATURE_OTHER_05") var resultStyle: ResultStyle = .lemontea
    let bossCounts: [Int]
    let result: RealmCoopResult
    //    let bossKillCounts: [Int]
    let playerBossKillCounts: [[Int]]
    
    init(result: RealmCoopResult) {
        self.result = result
        self.bossCounts = Array(result.bossCounts)
//        self.bossKillCounts = Array(result.bossKillCounts)
        self.playerBossKillCounts = Array(result.player.map({ Array($0.bossKillCounts) })).transpose()
        print(bossCounts)
        print(playerBossKillCounts)
    }
  
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false, content: {
                LazyVStack(spacing: nil, pinnedViews: [.sectionHeaders], content: {
                    Section(header: playerHeader, content: {
                        ForEach(Array(zip(Salmonid.allCases.indices, Salmonid.allCases)), id:\.0) { index, salmonid in
                            if bossCounts[index] > 0 {
                                switch resultStyle {
                                case .salmonrec:
                                    BarChartView(salmonId: salmonid, values: playerBossKillCounts[index], maxValue: bossCounts[index])
                                case .barleyural:
                                    CircleChartView(salmonId: salmonid, values: playerBossKillCounts[index], maxValue: bossCounts[index])
                                default:
                                    CircleChartView(salmonId: salmonid, values: playerBossKillCounts[index], maxValue: bossCounts[index])
                                }
                            }
                        }
                    })
                })
            })
        }
    }
    
    var playerHeader: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 60, maximum: 80)), count: 4), alignment: .center, spacing: nil, pinnedViews: [], content: {
            ForEach(result.player.indices, id:\.self) { index in
                VStack(alignment: .center, spacing: nil, content: {
                    URLImage(url: result.player[index].thumbnailURL, content: { thumbnailImage in
                        thumbnailImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .mask(Circle())
                    })
                    #warning("ここに金イクラとか表示する")
                })
            }
        })
    }
}

struct CircleChartView: View {
    let salmonId: Salmonid
    let values: [Int]
    let maxValue: Int
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 80)), count: values.count + 1), alignment: .center, spacing: 20, pinnedViews: [], content: {
            Image(salmonId: salmonId.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fill)
            ForEach(values.indices) { index in
                Circle()
                    .trim(from: 0.0, to: CGFloat(values[index]) / CGFloat(values.max()!))
                    .stroke(Color.dodgerblue, lineWidth: 5)
//                    .stroke(values[index] == values.max()! ? Color.safetyorange : Color.dodgerblue, lineWidth: 5)
                    .rotationEffect(.degrees(-90))
                    .background(
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 5)
                    )
                    .overlay(
                        Text("\(values[index])")
                            .splatfont2(.primary, size: 16),
                        alignment: .center
                    )
                    .padding(.horizontal, 4)
            }
        })
        .padding()
    }
}

struct BarChartView: View {
    let salmonId: Salmonid
    let colors: [Color] = [.venitianred, .deepskyblue, .salam, .turbo]
    let values: [Int]
    let maxValue: Int
    let maxWidth: CGFloat = min(340, UIScreen.main.bounds.width - 100)
    
    var body: some View {
        HStack(alignment: .center, spacing: nil, content: {
            Image(salmonId: salmonId.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: 60)
            VStack(alignment: .leading, spacing: 0, content: {
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: maxWidth, height: 20)
                    .overlay(
                        Text("\(maxValue)")
                            .splatfont2(.primary, size: 16),
                        alignment: .center
                    )
                HStack(alignment: .center, spacing: 0, content: {
                    ForEach(values.indices, id: \.self) { index in
                        Rectangle()
                            .fill(colors[index])
                            .frame(width: maxWidth * CGFloat(values[index]) / CGFloat(maxValue), height: 20)
                            .overlay(
                                Text("\(values[index])")
                                    .splatfont2(.white, size: 16),
                                alignment: .center
                            )
                    }
                })
            })
        })
        .padding()
    }
}

// 二次元行列の転置行列を計算する
extension Array where Element: Collection, Element.Index == Int {
    func transpose() -> [[Element.Element]] {
        return self.isEmpty ? [] : (0...(self.first!.endIndex - 1)).map { i -> [Element.Element] in self.map { $0[i] } }
    }
}

//struct CoopPlayerResultView_Previews: PreviewProvider {
//    static let result = RealmManager.shared.results.first!
//    static var previews: some View {
//        CoopPlayerResultView()
//            .previewLayout(.fixed(width: 414, height: 896))
//    }
//}
