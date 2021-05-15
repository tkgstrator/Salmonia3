//
//  CoopShiftCollection.swift
//  Salmonia3
//
//  Created by Devonly on 3/14/21.
//

import SwiftUI

struct CoopShiftCollection: View {
    @EnvironmentObject var main: CoreRealmCoop
    
    var body: some View {
        ScrollViewReader { _ in
            List {
                ForEach(main.shifts.indices) { index in
                    NavigationLink(destination: CoopShiftStatsView(startTime: main.shifts[index].startTime), label: {
                        CoopShift(shift: main.shifts[index])
                    })
                }
            }
        }
        .navigationTitle("TITLE_SHIFT_SCHEDULE")
    }
}

struct CoopShift: View {
    
    @StateObject var shift: RealmCoopShift
    @AppStorage("FEATURE_FREE_01") var isFree01: Bool = false
    
    var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy MM/dd HH:mm"
        return formatter
    }()

    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(shift.startTime))))
                    Text(verbatim: "-")
                    Text(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(shift.endTime))))
                }
                    .splatfont2(size: 16)
                InfoWeapon
            }
            .splatfont2(size: 14)
            Spacer()
        }
    }

    var InfoWeapon: some View {
        HStack {
            VStack(spacing: 0) {
                Image(StageType(rawValue: shift.stageId.intValue)!.md5)
                    .resizable().frame(width: 112, height: 63)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                Text(StageType(rawValue: shift.stageId.intValue)!.name.localized)
                    .splatfont2(size: 14)
                    .padding(.bottom, 8)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("SUPPLIED_WEAPONS")
                if isFree01 && shift.weaponList.contains(-1) {
                    AnyView(
                    LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 30, maximum: 50)), count: 5), alignment: .center, spacing: 0) {
                        ForEach(shift.weaponList.indices) { idx in
                            Image(String(shift.weaponList[idx]).imageURL)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
//                                .frame(maxWidth: 45)
                        }
                        Image(String(shift.rareWeapon.intValue).imageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
//                            .frame(maxWidth: 45)
                    }
                    .padding(.bottom, 20)
                    .frame(maxWidth: 200)
                    )
                } else {
                    AnyView(
                    LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 30, maximum: 50)), count: 4), alignment: .center, spacing: 0) {
                        ForEach(shift.weaponList.indices) { idx in
                            Image(String(shift.weaponList[idx]).imageURL)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 45)
                        }
                    }
                    .padding(.bottom, 20)
                    .frame(maxWidth: 200)
                    )
                }

            }
        }
    }
}

struct CoopShiftCollection_Previews: PreviewProvider {
    static var previews: some View {
        CoopShiftCollection()
    }
}
