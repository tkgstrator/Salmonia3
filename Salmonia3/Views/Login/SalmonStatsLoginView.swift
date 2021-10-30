//
//  SalmonStatsLoginView.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/19.
//

import SwiftUI
import SalmonStats

struct SalmonStatsLoginView: View {
    @EnvironmentObject var appManager: AppManager
    @State var isPresented: Bool = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                Group {
                    Text("Salmonia3")
                        .font(.custom("Splatfont2", size: 18))
                        .multilineTextAlignment(.center)
                        .lineLimit(5)
                        .padding(.horizontal, 20)
                        .foregroundColor(.whitesmoke)
                        .frame(width: min(geometry.size.width * 0.95, 400))
                    LazyVStack(content: {
                        //                    circleProgress
                        //                    Text("GETTING_\(signInState.localizedDescription)")
                        //                        .font(.custom("Splatfont2", size: 18))
                        //                        .transition(.scale)
                    })
                    //                    .visible(signInState != .none)
                        .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
                    SignInButton
                        .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).maxY - 100)
                }
            }
            .background(BackgroundWave())
            .navigationTitle("Salmonia3")
            .navigationBarBackButtonHidden(true)
        }
        .preferredColorScheme(.dark)
    }
    
    /// サインイン用のボタン
    var SignInButton: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blackrussian)
                .frame(width: 240, height: 60)
                .overlay(Text("Sign in").foregroundColor(.whitesmoke).font(.custom("Splatfont2", size: 20)))
        })
            .authorizeToken(isPresented: $isPresented, manager: appManager, completion: { result in
                switch result {
                    case .success(let value):
                        print(value)
                    case .failure(let error):
                        print(error)
                }
            })
    }
}

struct SalmonStatsLoginView_Previews: PreviewProvider {
    static var previews: some View {
        SalmonStatsLoginView()
    }
}
