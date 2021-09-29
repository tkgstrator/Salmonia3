//
//  ScheduleView.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/21.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI
import RealmSwift
import SDWebImageSwiftUI

struct ScheduleView: View {
    @Environment(\.presentationMode) var present
    @EnvironmentObject var appManager: AppManager
    @ObservedResults(RealmCoopShift.self, filter: NSPredicate("startTime", valuesIn: RealmManager.shared.shiftIds), sortDescriptor: SortDescriptor(keyPath: "startTime", ascending: false)) var shifts
    let playedShiftIds: [Int] = RealmManager.shared.shiftTimeList(nsaid: manager.playerId)
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(shifts) { shift in
                    ZStack(alignment: .center, content: {
                        NavigationLink(
                            destination: CoopShiftStatsView(startTime: shift.startTime)
                                .environmentObject(CoopShiftStats(startTime: shift.startTime)),
                            label: {
                                EmptyView()
                            })
                            .opacity(0.0)
                        CoopShiftView().environment(\.coopshift, shift)
                    })
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                            .opacity(playedShiftIds.contains(shift.startTime) ? 1.0 : 0.0)
                        , alignment: .topLeading)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(.TITLE_SHIFT_SCHEDULE)
    }

}

extension NSPredicate {
    public convenience init(_ property: String, valuesIn values: [Int]) {
        self.init(format: "\(property) IN %@", argumentArray: [values])
    }
}
