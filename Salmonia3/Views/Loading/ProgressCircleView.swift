//
//  ProgressCircleView.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/27.
//  
//

import SwiftUI
import SwiftyUI

struct ProgressCircleView: View {
    let current: Int
    let maximum: Int
    
    var value: CGFloat {
        if maximum == .zero {
            return .zero
        }
        return CGFloat(current) / CGFloat(maximum)
    }
    
    var body: some View {
        ZStack(content: {
            Circle()
                .trim(from: 0.0, to: value)
                .stroke(Color.white, lineWidth: 8)
                .rotationEffect(.degrees(-90))
                .frame(width: 140, height: 140, alignment: .center)
                .animation(.linear, value: current)
            Circle()
                .stroke(Color.white.opacity(0.5), lineWidth: 8)
                .frame(width: 140, height: 140, alignment: .center)
            Text(String(format: "%02d/%02d", current, maximum))
                .font(systemName: .ShareTechMono, size: 28, foregroundColor: .white)
        })
    }
}
//
//struct ProgressCircleView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProgressCircleView()
//    }
//}
