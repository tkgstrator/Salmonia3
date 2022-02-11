//
//  CircleProgressView.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/12.
//

import SwiftUI
import SplatNet2

struct CircleProgressView: View {
    @EnvironmentObject var service: AppService
    
    var body: some View {
        GeometryReader(content: { geometry in
            let frame = geometry.frame(in: .local)
            let width = min(geometry.frame(in: .local).width * 0.7, 200)
            ZStack(content: {
                Circle()
                    .trim(from: 0.0, to: service.signInState.progressValue)
                    .stroke(Color.blackrussian, lineWidth: 15)
                    .rotationEffect(Angle(degrees: -90))
                    .frame(width: width, height: width, alignment: .center)
                Circle()
                    .fill(Color.whitesmoke)
                    .frame(width: width, height: width, alignment: .center)
            })
                .position(x: frame.midX, y: frame.midY)
        })
            .background(BackgroundWave())
    }
}

fileprivate extension Optional where Wrapped == SignInState {
    var progressValue: Double {
        Double(self?.progress ?? 0) / Double(7)
    }
}

struct CircleProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircleProgressView()
            .preferredColorScheme(.dark)
            .environmentObject(AppService())
    }
}
