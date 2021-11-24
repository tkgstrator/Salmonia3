//
//  FireStats.swift
//  Salmonia3
//
//  Created by devonly on 2021/11/24.
//  
//

import SwiftUI
import SwiftyUI
import SplatNet2
import RealmSwift

struct FireStatsView: View {
    @EnvironmentObject var appManager: AppManager
    @ObservedResults(RealmCoopWave.self) var results
    @State var waves: [FSRecordWave] = []
    @State var records: [FireStats] = []
    let startTime: Int
    
    init(startTime: Int) {
        self.startTime = startTime
        $results.filter = NSPredicate(format: "ANY result.startTime=\(startTime)")
    }
    
    var body: some View {
        Form(content: {
            Section(content: {
                HStack(content: {
                    Text("Uploaded")
                    Spacer()
                    Text(waves.count)
                        .foregroundColor(.secondary)
                })
                HStack(content: {
                    Text("Total ikura num")
                    Spacer()
                    Text(waves.totalIkuraNum)
                        .foregroundColor(.secondary)
                })
                HStack(content: {
                    Text("Total golden ikura num")
                    Spacer()
                    Text(waves.totalGoldenIkuraNum)
                        .foregroundColor(.secondary)
                })
            }, header: {
                Text("Overview")
            })
            ForEach(Result.WaterKey.allCases) { waterLevel in
                Section(content: {
                    ForEach(Result.EventKey.allCases) { eventType in
                        if let record = records.filter({ $0.eventType == eventType && $0.waterLevel == waterLevel }).first {
                            HStack(content: {
                                Text(eventType.eventName)
                                Spacer()
                                Text(record.goldenIkuraNumRank)
                                    .foregroundColor(.secondary)
                            })
                        }
                    }
                }, header: {
                    Text(waterLevel.waterName)
                })
            }
        })
            .onAppear(perform: addSnapshotListener)
            .navigationTitle("FireStats")
    }
    
    /// 毎回呼び出すの絶対コスト重いからやりたくないマン
    func addSnapshotListener() {
        appManager
            .records
            .document(String(startTime))
            .collection("waves")
            .addSnapshotListener({ [self] snapshot, error in
                guard let snapshot = snapshot else {
                    return
                }
                waves = snapshot.decode(type: FSRecordWave.self)
                records = getWaveRank()
            })
    }
    
    func getWaveRank() -> [FireStats] {
        var records: [FireStats] = []
        // イベント, 潮位ごとに記録を抽出
        for waterLevel in Result.WaterKey.allCases {
            for eventType in Result.EventKey.allCases {
                // 無視するイベントと潮位の組み合わせ
                if (waterLevel == .low && [.rush, .goldieSeeking, .griller].contains(eventType)) || (waterLevel != .low && eventType == .cohockCharge) {
                    continue
                }
                let waves = waves.filter({ $0.eventType == eventType && $0.waterLevel == waterLevel })
                if let goldenIkuraNum: Int = results.filter("eventType=%@ AND waterLevel=%@", eventType.rawValue, waterLevel.rawValue).max(ofProperty: "goldenIkuraNum"),
                   let ikuraNum: Int = results.filter("eventType=%@ AND waterLevel=%@", eventType.rawValue, waterLevel.rawValue).max(ofProperty: "ikuraNum") {
                    records.append(FireStats(eventType: eventType, waterLevel: waterLevel, goldenIkuraNum: goldenIkuraNum, ikuraNum: ikuraNum, waves: waves))
                }
            }
        }
        return records
    }
}

struct FireStats {
    internal init(eventType: Result.EventKey, waterLevel: Result.WaterKey, goldenIkuraNum: Int, ikuraNum: Int, waves: [FSRecordWave]) {
        self.eventType = eventType
        self.waterLevel = waterLevel
        self.goldenIkuraNum = goldenIkuraNum
        self.ikuraNum = ikuraNum
        self.goldenIkuraNumRank = waves.map({ $0.goldenIkuraNum }).filter({ $0 > goldenIkuraNum }).count + 1
        self.ikuraNumRank = waves.map({ $0.ikuraNum }).filter({ $0 > ikuraNum }).count + 1
    }
    
    let eventType: Result.EventKey
    let waterLevel: Result.WaterKey
    let goldenIkuraNum: Int
    let ikuraNum: Int
    let goldenIkuraNumRank: Int
    let ikuraNumRank: Int
    
}

struct FireStatsView_Previews: PreviewProvider {
    static var previews: some View {
        FireStatsView(startTime: 0)
    }
}

extension Array where Element == FSRecordWave {
    var totalIkuraNum: Int {
        self.map({ $0.ikuraNum }).reduce(0, +)
    }
    
    var totalGoldenIkuraNum: Int {
        self.map({ $0.goldenIkuraNum }).reduce(0, +)
    }
}
