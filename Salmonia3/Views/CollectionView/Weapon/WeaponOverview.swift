//
//  WeaponOverview.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/06.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI

struct WeaponOverview: View {
    @StateObject var stats: WeaponShiftStats

    var body: some View {
        GeometryReader(content: { geometry in
            let suppliedWeaponCount: Int = stats.suppliedWeaponList.count
            HStack(content: {
                VStack(content: {
                    HStack(content: {
                        Text("推定所要バイト数")
                        Spacer()
                        Text("\(stats.estimateCompleteJobCount)回")
                    })
                    HStack(content: {
                        Text("バイト数")
                        Spacer()
                        Text("\(stats.jobCount)回")
                    })
                    HStack(content: {
                        Text("ブキコンプリート")
                        Spacer()
                        Text(suppliedWeaponCount == 51 ? "達成" : "未達成")
                    })
                })
                Spacer(minLength: 40)
                ZStack(content: {
                    Circle()
                        .fill(Color.white)
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .foregroundColor(.gray)
                    Circle()
                        .trim(from: 0.0, to: CGFloat(suppliedWeaponCount) / CGFloat(51))
                        .stroke(style: StrokeStyle(lineWidth: 12))
                        .rotationEffect(.degrees(-90))
                        .foregroundColor(.citrus)
                    Text("\(suppliedWeaponCount)/51")
                        .foregroundColor(.black)
                })
                    .frame(maxWidth: 120)
                    .padding()
            })
                .font(systemName: .Splatfont2, size: 16)
                .padding()
        })
            .aspectRatio(20/9, contentMode: .fit)
            .background(RoundedRectangle(cornerRadius: 6).fill(Color.whitesmoke))
//            .onAppear(perform: {
//                withAnimation(.easeInOut(duration: 1.5)) {
//                    self.scale = 1.0
//                }
//            })
    }
}

//struct WeaponOverview_Previews: PreviewProvider {
//    static var previews: some View {
//        WeaponOverview()
//    }
//}
