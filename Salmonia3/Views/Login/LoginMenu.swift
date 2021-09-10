//
//  LoginMenu.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/03/11.
//

import Foundation
import BetterSafariView
import SwiftUI
import SplatNet2
import Combine
import SDWebImageSwiftUI

struct LoginMenu: View {
    @State var angle: Angle = Angle(degrees: 0)
    @State var isPresented: Bool = false
    @State var isActive: Bool = false

    var body: some View {
        ZStack(alignment: .bottom, content: {
            ScrollView(.vertical, showsIndicators: false, content: {
                Text(.TEXT_WELCOME_SPLATNET2)
                    .font(.custom("Splatfont2", size: 18))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .offset(x: 0, y: 100)
                    .padding()
                    .foregroundColor(.whitesmoke)
            }).introspectScrollView(customize: { scrollView in
                scrollView.isScrollEnabled = false
            })
            signInButton
                .offset(x: 0, y: -140)
        })
        .background(Wave().edgesIgnoringSafeArea(.all))
        .navigationTitle(.TITLE_SALMONIA)
        .preferredColorScheme(.dark)
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
    }
   
    var signInButton: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            RoundedRectangle(cornerRadius: 10).fill(Color.whitesmoke).frame(width: 240, height: 50)
                .overlay(Text(.BTN_SIGN_IN).foregroundColor(.safetyorange).font(.custom("Splatfont2", size: 20)))
        })
        .padding()
        .authorize(isPresented: $isPresented, completion: { result in
            switch result {
            case .success:
                isActive.toggle()
            case .failure(let error):
                print(error)
            }
        })
        .overlay(NavigationLink(destination: SalmonLoginMenu(), isActive: $isActive, label: { EmptyView() }))
    }
}

struct Wave: View {
    @State var offset: Angle = Angle(degrees: 0)
    let height: CGFloat = UIScreen.main.bounds.height
    let width: CGFloat = UIScreen.main.bounds.width
    let color: Color = .safetyorange
    
    var body: some View {
        ZStack(alignment: .top, content: {
            Color.whitesmoke.frame(width: width, height: height).edgesIgnoringSafeArea(.all)
            CustomWave(startAngle: Angle(degrees: 0), offset: offset / 2)
                .fill(color.opacity(0.2))
                .frame(width: width, height: height * 1.05 * 4 / 5)
            CustomWave(startAngle: Angle(degrees: 0), offset: offset)
                .fill(color.opacity(0.5))
                .frame(width: width, height: height * 4 / 5)
            CustomWave(startAngle: Angle(degrees: 40), offset: -offset)
                .fill(color.opacity(0.9))
                .frame(width: width, height: height * 4 / 5)
        })
        .onAppear {
            withAnimation(Animation.linear(duration: 6).repeatForever(autoreverses: false)) {
                offset = Angle(degrees: 720)
            }
        }
    }
}

struct CustomWave: Shape {
    let graphWidth: CGFloat = 0.8
    let waveHeight: CGFloat = 30
    // 初期の位相ズレ
    let startAngle: Angle
    // アニメーションのためのオフセット
    var offset: Angle = Angle(degrees: 0)
    
    var animatableData: Double {
        get { offset.degrees }
        set { offset = Angle(degrees: newValue )}
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        //        path.move(to: CGPoint(x: rect.maxX + 5, y: waveHeight))
        path.move(to: CGPoint(x: rect.maxX + 5, y: rect.maxY - waveHeight))
        path.addLine(to: CGPoint(x: rect.maxX + 5, y: 0))
        path.addLine(to: CGPoint(x: -5, y: 0))
        path.addLine(to: CGPoint(x: -5, y: rect.maxY - waveHeight))
        
        for angle in stride(from: 0.0, to: 360.0, by: 1) {
            let theta: Double = Angle(degrees: startAngle.degrees + angle + offset.degrees).radians
            let x = CGFloat(angle / 360.0) * (rect.width + 10)
            let y = rect.maxY + CGFloat(sin(theta)) * waveHeight / 2 - waveHeight / 2
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.closeSubpath()
        return path
    }
    
}

extension WebImage {
    init(forResource: String, isAnimating: Binding<Bool>) {
        let url = Bundle.main.url(forResource: forResource, withExtension: "png")
        self.init(url: url, isAnimating: isAnimating)
    }
}

struct LoginMenu_PreviewProvider: PreviewProvider {
    static var previews: some View {
        LoginMenu()
    }
}
