//
//  StatsChartView.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/07/24.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftChart

struct StatsChartView: View {
    var stats: CoopShiftStats
    
    var body: some View {
        List {
            Section(header: Text(.HEADER_SPECIAL_WEAPON).splatfont2(.orange, size: 14)) {
                HStack {
                    Spacer()
                    PieChartView(data: (stats.overview.specialWeapon))
                        .frame(width: 300, height: 300, alignment: .center)
                    Spacer()
                }
            }
        }
    }
}
