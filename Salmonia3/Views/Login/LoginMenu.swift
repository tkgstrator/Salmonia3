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
    @State var signInState: SplatNet2.SignInState = .none
    @State var angle: Angle = Angle(degrees: 0)
    @State var isPresented: Bool = false
    @State var isActive: Bool = false
    let circleSize: CGSize = CGSize(width: 120, height: 120)
    
    var body: some View {
        ZStack(alignment: .bottom, content: {
            ScrollView(.vertical, showsIndicators: false, content: {
                Text(.TEXT_WELCOME_SPLATNET2)
                    .font(.custom("Splatfont2", size: 18))
                    .multilineTextAlignment(.center)
                    .lineLimit(5)
                    .offset(x: 0, y: 100)
                    .padding(.horizontal, 20)
                    .foregroundColor(.whitesmoke)
                    .frame(width: 340)
                circleProgress
                    .visible(signInState != .none)
                Text("GETTING_\(signInState.localizedDescription)")
                    .font(.custom("Splatfont2", size: 18))
                    .visible(signInState != .none)
                    .transition(.scale)
            }).introspectScrollView(customize: { scrollView in
                scrollView.isScrollEnabled = false
            })
            signInButton
                .offset(x: 0, y: -200)
        })
            .onReceive(NotificationCenter.default.publisher(for: SplatNet2.signIn), perform: { notification in
                withAnimation {
                    guard let state = notification.object as? SplatNet2.SignInState else { return }
                    signInState = state
                }
            })
            .frame(UIScreen.main.bounds.size)
            .background(Wave().edgesIgnoringSafeArea(.all))
            .navigationTitle(.TITLE_SALMONIA)
            .navigationBarItems(trailing: TutorialView())
            .preferredColorScheme(.dark)
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarBackButtonHidden(true)
    }
    
    var circleProgress: some View {
        Circle()
            .trim(from: 0.0, to: CGFloat(signInState.rawValue) / CGFloat(9))
            .stroke(Color.whitesmoke, lineWidth: 6)
            .rotationEffect(.degrees(-90))
            .frame(circleSize)
            .background(Circle()
                            .stroke(Color.envy, lineWidth: 6)
                            .frame(circleSize))
            .overlay(Circle().fill(Color.safetyorange.opacity(0.5)).frame(width: circleSize.width - 6, height: circleSize.height - 6))
            .background(Circle().fill(Color.white))
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
                    case .success(let value):
                        print(value)
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
    @State var isAnimating: Bool = false
    let height: CGFloat = UIScreen.main.bounds.height
    let width: CGFloat = UIScreen.main.bounds.width
    let color: Color = .safetyorange
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top, content: {
                Color.whitesmoke.edgesIgnoringSafeArea(.all)
                CustomWave(startAngle: Angle(degrees: 0), offset: offset / 2)
                    .fill(color.opacity(0.2))
                    .frame(width: geometry.frame(in: .local).width, height: geometry.frame(in: .local).height * 4 / 5 + 10)
                CustomWave(startAngle: Angle(degrees: 0), offset: offset)
                    .fill(color.opacity(0.5))
                    .frame(width: geometry.frame(in: .local).width, height: geometry.frame(in: .local).height * 4 / 5)
                CustomWave(startAngle: Angle(degrees: 40), offset: -offset)
                    .fill(color.opacity(0.9))
                    .frame(width: geometry.frame(in: .local).width, height: geometry.frame(in: .local).height * 4 / 5)
            })
        }
        .onAppear {
            isAnimating.toggle()
            if isAnimating {
                withAnimation(Animation.linear(duration: 6).repeatForever(while: true, autoreverses: false)) {
                    offset = Angle(degrees: 720)
                }
            }
        }
        .onDisappear {
            isAnimating.toggle()
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
        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY - waveHeight))
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY - waveHeight))
        
        for angle in stride(from: 0.0, to: 360.0, by: 0.5) {
            let theta: Double = Angle(degrees: startAngle.degrees + angle + offset.degrees).radians
            let x = CGFloat(angle / 360.0) * (rect.width)
            let y = rect.maxY + CGFloat(sin(theta)) * waveHeight / 2 - waveHeight / 2
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.closeSubpath()
        return path
    }
    
}

extension Animation {
    func `repeatForever`(while expression: Bool, autoreverses: Bool = false) -> Animation {
        if expression {
            return self.repeatForever(autoreverses: autoreverses)
        } else {
            return self
        }
    }
}


extension WebImage {
    init(forResource: String, isAnimating: Binding<Bool>) {
        let url = Bundle.main.url(forResource: forResource, withExtension: "png")
        self.init(url: url, isAnimating: isAnimating)
    }
}

extension SplatNet2.SignInState {
    var localizedDescription: String {
        switch self {
            case .none:
                return ""
            case .sessiontoken:
                return "session token"
            case .accesstoken:
                return "access token"
            case .s2shashnso:
                return "s2s hash"
            case .splatoontoken:
                return "splatoon token"
            case .splatoonaccesstoken:
                return "splatoon access token"
            case .iksmsession:
                return "iksm session"
            case .s2shashapp:
                return "s2s hash"
            case .flapgapp:
                return "f"
            case .flapgnso:
                return "f"
        }
    }
}

struct LoginMenu_PreviewProvider: PreviewProvider {
    static var previews: some View {
        LoginMenu()
    }
}
