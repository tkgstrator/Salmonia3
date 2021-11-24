//
//  FireStats.swift
//  Salmonia3
//
//  Created by devonly on 2021/11/24.
//  
//

import SwiftUI
import SplatNet2

struct FireStatsView: View {
    @EnvironmentObject var appManager: AppManager
    
    init() {
        
    }
    
    var body: some View {
        Form(content: {
            Section(content: {
                HStack(content: {
                    Text("Uploaded")
                    Spacer()
                    //                        Text(appManager.firerecords.count)
                    //                            .foregroundColor(.secondary)
                })
                HStack(content: {
                    Text("Total ikura num")
                    Spacer()
                    //                        Text(appManager.firerecords.totalIkuraNum)
                    //                            .foregroundColor(.secondary)
                })
                HStack(content: {
                    Text("Total golden ikura num")
                    Spacer()
                    //                        Text(appManager.firerecords.totalGoldenIkuraNum)
                    //                            .foregroundColor(.secondary)
                })
            }, header: {
                Text("Overview")
            })
            ForEach(Result.WaterKey.allCases) { waterLevel in
                Section(content: {
                    ForEach(Result.EventKey.allCases) { eventType in
                        HStack(content: {
                            Text(eventType.eventName)
                            Spacer()
                            Text(0)
                                .foregroundColor(.secondary)
                        })
                    }
                }, header: {
                    Text(waterLevel.waterName)
                })
            }
        })
            .navigationTitle("FireStats")
    }
}

struct FireStatsView_Previews: PreviewProvider {
    static var previews: some View {
        FireStatsView()
    }
}

extension Array where Element == FireRecord {
    var totalIkuraNum: Int {
        self.map({ $0.ikuraNum }).reduce(0, +)
    }
    
    var totalGoldenIkuraNum: Int {
        self.map({ $0.goldenIkuraNum }).reduce(0, +)
    }
}
