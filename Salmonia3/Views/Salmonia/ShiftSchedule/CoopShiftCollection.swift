//
//  CoopShiftCollection.swift
//  Salmonia3
//
//  Created by tkgstrator on 3/14/21.
//

import SwiftUI
import RealmSwift

// シフト一覧を表示
struct CoopShiftCollection: View {
    @Environment(\.presentationMode) var present
    @EnvironmentObject var appManager: AppManager
    @State var shifts: RealmSwift.Results<RealmCoopShift>
    var shiftNumber: Int
    let playedShiftIds: [Int] = RealmManager.shared.shiftTimeList(nsaid: manager.playerId)
    
    init(displayFutureShift: Bool) {
        self._shifts = State(initialValue: RealmManager.shared.allShiftStartTime(displayFutureShift: displayFutureShift))
        self.shiftNumber = RealmManager.shared.shiftNumber(displayFutureShift: displayFutureShift)
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(shifts.indices, id:\.self) { index in
                    ZStack(alignment: .leading) {
                        NavigationLink(
                            destination: CoopShiftStatsView(startTime: shifts[index].startTime)
                                .environmentObject(CoopShiftStats(startTime: shifts[index].startTime)),
                            label: {
                                EmptyView()
                            })
                        .opacity(0.0)
                        CoopShift(shift: shifts[index])
                    }
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                            .opacity(playedShiftIds.contains(shifts[index].startTime) ? 1.0 : 0.0)
                             , alignment: .topLeading)
                    .tag(index)
                }
            }
            .onAppear{ scrollTo(proxy: proxy) }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(.TITLE_SHIFT_SCHEDULE)
    }
    
    private func scrollTo(proxy: ScrollViewProxy) {
        if !present.wrappedValue.isPresented {
            proxy.scrollTo(shiftNumber, anchor: .center)
        }
    }
}

struct CoopShift: View {
    @EnvironmentObject var appManager: AppManager
    @StateObject var shift: RealmCoopShift
    var average: (power: Double?, golden: Double?)?
    var maximum: (power: Int?, golden: Int?)?

    var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy MM/dd HH:mm"
        return formatter
    }()
    
    init(shift: RealmCoopShift, results: RealmSwift.Results<RealmCoopResult>? = nil) {
        self._shift = StateObject(wrappedValue: shift)
        
        if let results = results {
            average = (power: results.average(ofProperty: "powerEggs"), golden: results.average(ofProperty: "goldenEggs"))
            maximum = (power: results.max(ofProperty: "powerEggs"), golden: results.max(ofProperty: "goldenEggs"))
        }
    }
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(shift.startTime))))
                Text(verbatim: "-")
                Text(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(shift.endTime))))
            }
            .splatfont2(size: 16)
            InfoWeapon
        }
        .frame(maxWidth: .infinity)
    }
    
    var InfoWeapon: some View {
        HStack {
            VStack(spacing: 0) {
                Image(stageId: shift.stageId)
                    .resizable().frame(width: 112, height: 63)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                Text(StageType(rawValue: shift.stageId)!.localizedName)
                    .splatfont2(size: 16)
                    .textCase(nil)
                    .padding(.bottom, 8)
            }
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(.SUPPLIED_WEAPONS)
                        .textCase(nil)
                        .splatfont2(size: 16)
                    // 金イクラ数平均とか出すと良いかも
                    Spacer()
                    if let average = average {
                        HStack {
                            Image(Egg.golden).resize()
                            Text("x\(average.golden.stringValue)")
                                .splatfont2(size: 14)
                                .textCase(nil)
                        }
                    }
                }
                .frame(maxWidth: 250)
                if appManager.isFree01 && shift.weaponList.contains(-1) {
                    AnyView(
                        LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 30, maximum: 50)), count: 5), alignment: .center, spacing: 0) {
                            ForEach(shift.weaponList.indices) { idx in
                                Image(weaponId: shift.weaponList[idx])
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 45)
                            }
                            Image(weaponId: shift.rareWeapon!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 45)
                        }
                        .padding(.bottom, 20)
                        .frame(maxWidth: 250)
                    )
                } else {
                    AnyView(
                        LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 30, maximum: 50)), count: 4), alignment: .center, spacing: 0) {
                            ForEach(shift.weaponList.indices) { idx in
                                Image(weaponId: shift.weaponList[idx])
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 45)
                            }
                        }
                        .padding(.bottom, 20)
                        .frame(maxWidth: 250)
                    )
                }
                
            }
        }
    }
}
//
//struct CoopShiftCollection_Previews: PreviewProvider {
//    static var previews: some View {
//        CoopShiftCollection()
//    }
//}
