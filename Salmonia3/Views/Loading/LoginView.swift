//
//  LoginView.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/27.
//  
//

import SwiftUI
import SplatNet2

struct LoginView: View {
    @StateObject var service: LoginService
    @Environment(\.dismiss) var dismiss
    @State private var sp2Error: SP2Error?
    @State private var isPresented: Bool = false
    
    var body: some View {
        GeometryReader(content: { geometry in
            LoggingThread()
            ProgressCircleView(current: service.current, maximum: service.maximum)
                .position(geometry.center)
        })
            .background(BackgroundWave())
            .onReceive(NotificationCenter.default.publisher(for: .didFinishedLogin), perform: { response in
                if let sp2Error = response.object as? SP2Error {
                    self.sp2Error = sp2Error
                    self.isPresented = true
                } else {
                    dismiss()
                }
            })
            .alert(isPresented: $isPresented, error: sp2Error, actions: { error in
                Button("OK", action: {
                    dismiss()
                })
            }, message: { error in
                Text(error.failureReason ?? "Unknown error.")
            })
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
