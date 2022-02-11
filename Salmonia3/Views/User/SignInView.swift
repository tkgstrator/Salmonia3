//
//  SignInView.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/12.
//

import SwiftUI
import SplatNet2

struct SignInView: View {
    @EnvironmentObject var service: AppService
    @State var isPresented: Bool = false
    
    var body: some View {
        
        Button(action: {
            isPresented.toggle()
        }, label: {
            Text("SIGNIN.SPLATNET2")
        })
            .authorize(isPresented: $isPresented, session: service.session)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
