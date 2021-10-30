//
//  ResultView.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/24.
//

import SwiftUI

struct ResultView: View {
    let result: RealmCoopResult
    
    fileprivate var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy MM/dd HH:mm"
        return formatter
    }()
    
    init(_ result: RealmCoopResult) {
        self.result = result
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            Image(result.stageId).resizable().frame(height: 120).aspectRatio(contentMode: .fit)
                .overlay(ResultOverview)
            ResultWave
        })
        
    }
    
    var ResultOverview: some View {
        VStack(alignment: .center, spacing: 0, content: {
            Text(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(result.playTime))))
                .shadow(color: .black, radius: 0, x: 2, y: 2)
                .font(.Splatfont2, size: 20, foregroundColor: .white)
            Text("RESULT_HAZARD_LEVEL_MAX")
                .font(.Splatfont2, size: 20, foregroundColor: .yellow)
            HStack(content: {
                Image(.golden)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 24, height: 24)
                Text("x\(result.goldenEggs)")
                Image(.power)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 24, height: 24)
                Text("x\(result.powerEggs)")
            })
                .shadow(color: .black, radius: 0, x: 1, y: 1)
                .font(.Splatfont2, size: 20, foregroundColor: .white)
        })
    }
    
    var ResultWave: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 200), alignment: .top), count: result.wave.count)) {
            ForEach(result.wave) { wave in
                VStack(alignment: .center, spacing: 0, content: {
                    VStack(spacing: 0, content: {
                        Text("RESULT_WAVE_")
                            .foregroundColor(.black)
                        Text("\(wave.goldenIkuraNum)/\(wave.quotaNum)")
                            .font(.Splatfont2, size: 22, foregroundColor: .white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 36)
                            .minimumScaleFactor(1.0)
                            .backgroundFill(.maire)
                        Text("\(wave.ikuraNum)")
                            .foregroundColor(.red)
                            .frame(height: 26)
                            .minimumScaleFactor(1.0)
                        Text(wave.waterLevel.localizedName)
                            .foregroundColor(.black)
                            .frame(height: 26)
                            .minimumScaleFactor(1.0)
                        Text(wave.eventType.localizedName)
                            .foregroundColor(.black)
                            .frame(height: 26)
                            .minimumScaleFactor(1.0)
                    })
                        .background(RoundedRectangle(cornerRadius: 4).fill(Color.yellow))
                        .frame(minHeight: 140)
                    HStack(content: {
                        Image(.golden)
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text("RESULT_APPEARANCES_\(wave.goldenIkuraPopNum)")
                            .font(.Splatfont2, size: 13)
                            .lineLimit(1)
                    })
//                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), alignment: .leading, spacing: 0, pinnedViews: []) {
//                        ForEach(wave.specialUsage.indices) { index in
//                            Image(specialId: wave.specialUsage[index])
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                        }
//                    }
                })
            }
        }
        .font(.Splatfont2, size: 16, foregroundColor: .white)
    }
}

//struct ResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultView()
//    }
//}
