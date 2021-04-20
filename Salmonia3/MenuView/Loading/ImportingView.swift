//
//  ImportingView.swift
//  Salmonia3
//
//  Created by devonly on 2021/04/18.
//

import SwiftUI
import SalmonStats

struct ImportingView: View {
    @Environment(\.presentationMode) var present
    @State var data: ProgressData = ProgressData()
    
    private func dismiss() {
        DispatchQueue.main.async { present.wrappedValue.dismiss() }
    }
    
    var body: some View {
        LoggingThread(data: $data)
            .onAppear {
                
            }
    }
}

struct ImportingView_Previews: PreviewProvider {
    static var previews: some View {
        ImportingView()
    }
}
