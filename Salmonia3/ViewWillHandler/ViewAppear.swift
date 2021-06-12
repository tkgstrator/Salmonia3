//
//  ViewAppear.swift
//  Salmonia3
//
//  Created by devonly on 2021/06/11.
//

import Foundation
import SwiftUI

extension View {
    func onAppear(item: Binding<Any?>, _ perform: @escaping (() -> Void)) -> some View {
        if let _ = item.wrappedValue {
            return AnyView(self)
        } else {
            return AnyView(self.onAppear(perform: perform))
        }
    }
}

