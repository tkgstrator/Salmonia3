//
//  ShiftFilterButton.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/26.
//

import SwiftUI

struct ShiftFilterButton: View {
    @EnvironmentObject var service: AppService
    
    var body: some View {
        Picker(selection: $service.shiftDisplayMode, content: {
            ForEach(ShiftDisplayMode.allCases) { mode in
                Text(mode.description)
                    .tag(mode)
            }
        }, label: {
        })
            .pickerStyle(.wheel)
    }
}
//
//struct ShiftFilterButton_Previews: PreviewProvider {
//    static var previews: some View {
//        ShiftFilterButton()
//    }
//}
