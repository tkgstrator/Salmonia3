//
//  LoadingView.swift
//  Salmonia3
//
//  Created by Devonly on 3/13/21.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    @Environment(\.presentationMode) var present
    @State var data: ProgressData = ProgressData()
    
    var body: some View {
        LoggingThread(data: $data)
        Button(action: { present.wrappedValue.dismiss() }, label: { Text("BTN_BACK") })
    }
}
