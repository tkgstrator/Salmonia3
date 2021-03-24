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
        ScrollViewReader { proxy in
            List {
                ForEach(main.shifts.indices) { index in
                    NavigationLink(destination: CoopShiftStatsView(startTime: main.shifts[index].startTime!), label: {
                        CoopShift(shift: main.shifts[index])
                    })
                }
            }
        }
        .navigationTitle("TITLE_SHIFT_COLLECTION")
    }
}

struct CoopShift: View {
    @ObservedObject var shift: RealmCoopShift
    var columns: [GridItem] = Array(repeating: GridItem(), count: 4)
    
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .leading, spacing: 10) {
                Text(shift.startTime.stringValue)
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
                Text(StageType(rawValue: shift.stageId.intValue)!.name)
                    .splatfont2(size: 14)
                    .padding(.bottom, 8)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("SUPPLIED_WEAPONS")
                LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                    ForEach(shift.weaponList.indices) { idx in
                        Image(String(shift.weaponList[idx]).imageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 45)
                    }
                }
                .padding(.bottom, 20)
                .frame(maxWidth: 200)
            }
        }
    }
}

struct CoopShiftCollection_Previews: PreviewProvider {
    static var previews: some View {
        CoopShiftCollection()
    }
}
