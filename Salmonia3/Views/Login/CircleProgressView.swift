//
//  CircleProgressView.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/12.
//

import SwiftUI
import SplatNet2
import SwiftyUI

struct CircleProgressView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var service: AppService
    let description: String
    let doubleValue: Double
    
    init(state: SignInState?) {
        self.doubleValue = {
            if let state = state {
                return Double(state.id) / Double(7)
            }
            return .zero
        }()
        self.description = {
            if let currentValue = state?.id {
                return String(format: "%02d/%02d", currentValue, 7)
            }
            return "-/-"
        }()
    }
    
    init(progress: ProgressModel?) {
        self.doubleValue = {
            if let progress = progress {
                return Double(progress.totalCount - (progress.maximum - progress.current)) / Double(progress.totalCount)
            }
            return .zero
        }()
        self.description = {
            if let progress = progress {
                return String(format: "%02d/%02d", progress.totalCount - (progress.maximum - progress.current), progress.totalCount)
            }
            return "-/-"
        }()
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            let frame = geometry.frame(in: .local)
            let width = min(geometry.frame(in: .local).width * 0.7, 200)
            ZStack(content: {
                Circle()
                    .trim(from: 0.0, to: doubleValue)
                    .stroke(Color.blackrussian, lineWidth: 15)
                    .rotationEffect(Angle(degrees: -90))
                    .frame(width: width, height: width, alignment: .center)
                Circle()
                    .fill(Color.blue)
                    .frame(width: width, height: width, alignment: .center)
                Text(description)
                    .font(systemName: .Splatfont2, size: 30)
                    .foregroundColor(.secondary)
            })
                .position(x: frame.midX, y: frame.midY)
        })
            .alert(isPresented: $service.isErrorPresented, error: service.sp2Error, actions: { error in
                Button("OK", action: {
                    service.sp2Error = nil
                    dismiss()
                })
            }, message: { error in
                Text(error.failureReason ?? "Unknown error.")
            })
    }
}

extension Optional where Wrapped == SignInState {
    var progressValue: Double {
        Double(self?.progress ?? 0) / Double(7)
    }
    
    var identifier: String {
        switch self {
        case .none:
            return "WAITING"
        case .some(let value):
            switch value {
            case .iksmSession:
                return "IKSMSESSION"
            case .accessToken(let value):
                return value == .nso ? "ACCESSTOKEN" : "SPLATOONACCESSTOKEN"
            case .s2sHash(let value):
                return value == .nso ? "S2SHASHNSO" : "S2SHASHAPP"
            case .flapg(let value):
                return value == .nso ? "FLAPGNSO" : "FLAPGNSOAPP"
            case .sessionToken(let value):
                return value == .nso ? "SESSIONTOKEN" : "SPLATOONTOKEN"
            }
        }
    }
}

struct CircleProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircleProgressView(state: .s2sHash(.nso))
            .preferredColorScheme(.light)
            .environmentObject(AppService())
    }
}
