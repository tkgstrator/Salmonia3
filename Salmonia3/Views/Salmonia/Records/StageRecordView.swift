//
//  StageRecordView.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/23.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftUIX
import Introspect

struct StageRecordView: View {
    @EnvironmentObject var result: CoreRealmCoop
    @State var recordType: RecordType = .golden
    
    enum RecordType: Int, CaseIterable {
        case golden
        //        case power
        case overview
        
        mutating func toggle() {
            self = RecordType(rawValue: (self.rawValue + 1) % RecordType.allCases.count)!
        }
    }
    
    var toggleButton: some View {
        Button(action: {
            recordType.toggle()
        }, label: {
            Image(systemName: "switch.2")
                .resizable()
                .aspectRatio(contentMode: .fit)
        })
    }
    
    var recordOverview: some View {
        PaginationView {
            ForEach(StageType.allCases, id:\.rawValue) { stageId in
                NavigationView {
                    RecordOverview(record: result.records.overview.filter({ $0.stageId == stageId }).first!)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle(stageId.localizedName)
                        .navigationBarItems(trailing: toggleButton)
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
        .edgesIgnoringSafeArea(.top)
        .pageIndicatorTintColor(.primary)
    }
    
    var recordView: some View {
        PaginationView {
            ForEach(StageType.allCases, id:\.rawValue) { stageId in
                NavigationView {
                    RecordView(records: result.records.records.filter({ $0.stageId == stageId }))
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle(stageId.localizedName)
                        .navigationBarItems(trailing: toggleButton)
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
        .edgesIgnoringSafeArea(.top)
        .pageIndicatorTintColor(.primary)
    }
    
    var body: some View {
        switch recordType {
            case .overview:
                recordOverview
            default:
                recordView
        }
    }
}

private struct RecordOverview: View {
    let record: UserCoopRecord.Overview
    
    var body: some View {
        List {
            HStack(content: {
                Text(.RESULT_JOB_NUM)
                Spacer()
                Text(record.jobNum.stringValue)
                    .foregroundColor(.secondary)
            })
            HStack(content: {
                Text(.RESULT_MAX_GRADE)
                Spacer()
                Text(record.maxGrade.stringValue)
                    .foregroundColor(.secondary)
            })
            HStack(content: {
                Text(.RESULT_MAX_GRADE_NUM)
                Spacer()
                Text(record.counter999Num.stringValue)
                    .foregroundColor(.secondary)
            })
            HStack(content: {
                Text(.RESULT_MIN_MAX_GRADE)
                Spacer()
                Text(record.counter999StepNum.stringValue)
                    .foregroundColor(.secondary)
            })
        }
        .splatfont2(size: 16)
    }
}

private struct RecordView: View {
    @State var waterLevel: WaterLevel = .middle
    let records: [UserCoopRecord.Record]
    
    /// 夜込み記録
    var nightRecordView: some View {
        VStack(alignment: .leading, spacing: 4, content: {
            HStack(alignment: .center, spacing: nil) {
                Text(.NIGHT_WAVE).font(.custom("Splatfont2", size: 16))
                Spacer()
            }
            .padding(.leading)
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count:3), alignment: .center, spacing: nil, pinnedViews: [], content: {
                ForEach(records.filter({ $0.recordType == .total })) { record in
                    switch UIDevice.current.userInterfaceIdiom {
                        case .phone:
                            RecordCardViewPhone(record: record)
                        default:
                            RecordCardViewPad(record: record)
                    }
                }
            })
        })
    }
    
    /// 昼のみ記録
    var nonightRecordView: some View {
        VStack(alignment: .leading, spacing: 4, content: {
            HStack(alignment: .center, spacing: nil) {
                Text(.NO_NIGHT_WAVE).font(.custom("Splatfont2", size: 16))
                Spacer()
            }
            .padding(.leading)
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count:3), alignment: .center, spacing: nil, pinnedViews: [], content: {
                ForEach(records.filter({ $0.recordType == .nonight })) { record in
                    switch UIDevice.current.userInterfaceIdiom {
                        case .phone:
                            RecordCardViewPhone(record: record)
                        default:
                            RecordCardViewPad(record: record)
                    }
                }
            })
        })
    }
    
    var waveRecordView: some View {
        ForEach(EventType.allCases, id:\.rawValue) { eventType in
            if records.filter({ $0.waterLevel == waterLevel && $0.eventType == eventType && $0.recordType == .wave }).map({ $0.goldenEggs }).reduce(0, +) != 0 {
                VStack(alignment: .leading, spacing:4, content: {
                    HStack(alignment: .center, spacing: nil) {
                        Text(eventType.localizedName).font(.custom("Splatfont2", size: 16))
                        Spacer()
                    }
                    .padding(.leading)
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), alignment: .center, spacing: nil, pinnedViews: [], content: {
                        ForEach(records.filter({ $0.waterLevel == waterLevel && $0.eventType == eventType && $0.recordType == .wave })) { record in
                            switch UIDevice.current.userInterfaceIdiom {
                                case .phone:
                                    RecordCardViewPhone(record: record)
                                default:
                                    RecordCardViewPad(record: record)
                            }
                        }
                    })
                })
            }
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false, content: {
            Picker("WATER_LEVEL", selection: $waterLevel) {
                ForEach(WaterLevel.allCases, id:\.rawValue) { waterLevel in
                    Text(waterLevel.localizedName)
                        .tag(waterLevel)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            nightRecordView
            nonightRecordView
            waveRecordView
        })
    }
    
    private struct RecordCardViewPhone: View {
        let record: UserCoopRecord.Record
        
        var body: some View {
            VStack(alignment: .trailing, spacing: 4, content: {
                HStack(alignment: .center, spacing: nil, content: {
                    Image(.golden)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 14, height: 14)
                    Text("x\(record.goldenEggs)")
                        .font(.custom("Splatfont2", size: 14))
                        .frame(height: 22)
                        .foregroundColor(.yellow)
                })
                    .padding(.horizontal, 8)
                    .background(Capsule().fill(Color.black.opacity(0.8)))
                LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 2), count: 4), alignment: .center, spacing: 0, content: {
                    ForEach(record.weaponList.indices) { index in
                        Image(weaponId: record.weaponList[index])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(2)
                            .background(Circle().fill(Color.black.opacity(0.95)))
                    }
                })
                    .padding(.top, 6)
            })
                .padding(4)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.safetyorange))
        }
    }
    
    private struct RecordCardViewPad: View {
        @EnvironmentObject var appManager: AppManager
        @State var isPresented: Bool = false
        let record: UserCoopRecord.Record
        
        var playerList: some View {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), alignment: .center, spacing: nil, pinnedViews: [], content: {
                ForEach(record.players, id:\.self) { player in
                    Text(player.nickname)
                        .font(.custom("Splatfont2", size: 16))
                        .foregroundColor(.whitesmoke)
                        .shadow(color: .black, radius: 0, x: 0, y: 2)
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
                        .foregroundColor(.whitesmoke)
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
                        .foregroundColor(.whitesmoke)
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
            Button(action: {
                isPresented.toggle()
            }, label: {
                VStack(alignment: .center, spacing: 0, content: {
                    recordDetail
                    weaponList
                    playerList
                })
                    .padding(6)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.safetyorange))
            })
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: $isPresented, content: {
                    CoopResultView(result: RealmManager.shared.result(playTime: record.playTime))
                        .environmentObject(appManager)
                })
        }
    }
}

struct StageRecordView_Previews: PreviewProvider {
    static var previews: some View {
        StageRecordView()
    }
}
