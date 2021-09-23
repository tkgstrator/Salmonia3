//
//  StageRecordView.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/23.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftUIX

struct StageRecordView: View {
    @EnvironmentObject var result: CoreRealmCoop
    
    var body: some View {
        PaginationView {
            ForEach(StageType.allCases, id:\.rawValue) { stageId in
                NavigationView {
                    RecordView(records: result.records.records.filter({ $0.stageId == stageId }))
                        .navigationTitle(stageId.localizedName)
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }
}

private struct RecordView: View {
    let records: [UserCoopRecord.Record]
    
    var body: some View {
        ScrollView(showsIndicators: false, content: {
            ForEach(WaterLevel.allCases, id:\.rawValue) { waterLevel in
                ForEach(EventType.allCases, id:\.rawValue) { eventType in
                    if records.filter({ $0.waterLevel == waterLevel && $0.eventType == eventType }).map({ $0.goldenEggs }).reduce(0, +) != 0 {
                        Section(header: Text("\(waterLevel.localizedName) - \(eventType.localizedName)").font(.custom("Splatfont2", size: 20)), content: {
                            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), alignment: .center, spacing: nil, pinnedViews: [], content: {
                                ForEach(records.filter({ $0.waterLevel == waterLevel && $0.eventType == eventType })) { record in
                                    RecordCardViewPad(record: record)
                                }
                            })
                        })
                    }
                }
            }
        })
    }
    
    private struct RecordCardViewPhone: View {
        let record: UserCoopRecord.Record
        
        var body: some View {
            HStack(alignment: .center, spacing: nil, content: {
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), alignment: .center, spacing: nil, pinnedViews: [], content: {
                    ForEach(record.players, id:\.self) { player in
                        Text(player.nickname)
                            .font(.custom("Splatfont2", size: 12))
                    }
                })
                Spacer()
                VStack(alignment: .trailing, spacing: 0, content: {
                    HStack(alignment: .center, spacing: nil, content: {
                        Image(.golden)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                        Text("x\(record.goldenEggs)")
                            .font(.custom("Splatfont2", size: 12))
                    })
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), alignment: .center, spacing: 0, content: {
                        ForEach(record.weaponList.indices) { index in
                            Image(weaponId: record.weaponList[index])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                        }
                    })
                })
            })
            .padding()
            .foregroundColor(.seashell)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray))
        }
    }
    
    private struct RecordCardViewPad: View {
        let record: UserCoopRecord.Record
        
        var playerList: some View {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), alignment: .center, spacing: nil, pinnedViews: [], content: {
                ForEach(record.players, id:\.self) { player in
                    Text(player.nickname)
                        .font(.custom("Splatfont2", size: 16))
                }
            })
        }
        
        var recordDetail: some View {
            LazyHStack(alignment: .center, spacing: nil, content: {
                HStack(alignment: .center, spacing: nil, content: {
                    Image(.power)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                    Text("x\(record.powerEggs)")
                        .font(.custom("Splatfont2", size: 18))
                        .minimumScaleFactor(1.0)
                })
                .padding(.horizontal)
                .background(Capsule().fill(Color.black.opacity(0.8)))
                HStack(alignment: .center, spacing: nil, content: {
                    Image(.golden)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                    Text("x\(record.goldenEggs)")
                        .font(.custom("Splatfont2", size: 18))
                        .minimumScaleFactor(1.0)
                })
                .padding(.horizontal)
                .background(Capsule().fill(Color.black.opacity(0.8)))
            })
        }
        
        var weaponList: some View {
            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 45)), count: 4), alignment: .center, spacing: nil, content: {
                ForEach(record.weaponList.indices) { index in
                    Image(weaponId: record.weaponList[index])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(4)
                        .background(Circle().fill(Color.black.opacity(0.95)))
                }
            })
            .padding(.vertical, 4)
        }
        
        var body: some View {
            VStack(alignment: .center, spacing: 0, content: {
                weaponList
                recordDetail
                playerList
            })
//            .foregroundColor(.seashell)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.safetyorange))
        }
    }
}

struct StageRecordView_Previews: PreviewProvider {
    static var previews: some View {
        StageRecordView()
    }
}
