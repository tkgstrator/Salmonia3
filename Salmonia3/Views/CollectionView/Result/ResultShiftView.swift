//
//  ResultShiftView.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/03.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI

struct ResultShiftView: View {
    let schedule: RealmCoopShift
    @State var isPresented: Bool = false
    
    var body: some View {
        Section(content: {
            ForEach(schedule.results.sorted(byKeyPath: "playTime", ascending: false)) { result in
                NavigationLinker(destination: ResultView(result), label: {
                    ResultOverview(result)
                })
            }
        }, header: {
            ShiftView(shift: schedule)
        })
//        DisclosureGroup(isExpanded: $isPresented, content: {
//            ForEach(schedule.results.sorted(byKeyPath: "playTime", ascending: false)) { result in
//                NavigationLinker(destination: ResultView(result), label: {
//                    ResultOverview(result)
//                })
//            }
//        }, label: {
//            ShiftView(shift: schedule)
//        })
    }
}

//struct ResultShiftView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultShiftView()
//    }
//}
