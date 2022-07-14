//
//  SignIn.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/31.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftyUI
import SalmonStats
import SplatNet2
import SDWebImageSwiftUI
import Common

enum SignIn {}

extension View {
    func backgroundView() -> some View {
        self.background(Wavecard().fill(Color.whitesmoke).scaledToFit().clipShape(RoundedRectangle(cornerRadius: 6)))
    }
   
    func backgroundCard(_ backgroundColor: Color = .clear, aspectRatio: CGFloat = 120 / 300) -> some View {
        self.background(
        GeometryReader(content: { geometry in
            let height: CGFloat = geometry.width * aspectRatio
            Hanger()
                .fill(backgroundColor)
                .aspectRatio(400/500, contentMode: .fill)
                .frame(width: geometry.width, height: height, alignment: .top)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }))
    }
}


extension SignIn {
    struct User: View {
        @EnvironmentObject var service: LoadingService
        @State private var isPresented: Bool = false

        var body: some View {
            let account: UserInfo = {
                if service.session.accounts.isEmpty {
                    var user = UserInfo(
                        nsaid: "0000000000000000",
                        membership: false,
                        friendCode: "XXXX-XXXX-XXXX",
                        sessionToken: "",
                        splatoonToken: "",
                        iksmSession: "",
                        thumbnailURL: URL(unsafeString: "https://cdn-image-e0d67c509fb203858ebcb2fe3f88c2aa.baas.nintendo.com/1/07938e82b382e840"),
                        nickname: "みなかみはちみ"
                    )
                    user.resultCoop = CoopInfo(
                        jobNum: 99999,
                        goldenIkuraTotal: 999999999,
                        ikuraTotal: 999999999,
                        kumaPoint: 999999999,
                        kumaPointTotal: 999999999
                    )
                    return user
                }
                return service.session.account
            }()
            SignIn.UserView(account: account)
        }
    }
    
    private struct UserView: View {
        @EnvironmentObject var service: LoadingService
        @State private var isPresented: Bool = false
        let account: UserInfo

        var body: some View {
            GeometryReader(content: { geometry in
                let scale: CGFloat = geometry.width / 375
                VStack(alignment: .leading, spacing: 0 * scale, content: {
                    HStack(spacing: nil, content: {
                        Button(action: {
                            isPresented.toggle()
                        }, label: {
                            WebImage(url: account.thumbnailURL)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 65 * scale, height: 65 * scale, alignment: .center)
                        })
                        .disabled(account.credential.nsaid == "0000000000000000")
                        Text(account.nickname)
                            .font(systemName: .Splatfont2, size: 24 * scale)
                            .padding()
                        Spacer()
                    })
                    .frame(maxHeight: .infinity)
                    HStack(spacing: nil, content: {
                        HStack(content: {
                            Image(.power)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22 * scale, height: 22 * scale, alignment: .center)
                            Text(account.resultCoop.ikuraTotal)
                        })
                        Spacer()
                        HStack(content: {
                            Image(.golden)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22 * scale, height: 22 * scale, alignment: .center)
                            Text(account.resultCoop.goldenIkuraTotal)
                        })
                    })
                    .font(systemName: .Splatfont2, size: 16 * scale)
//                    HStack(alignment: .center, spacing: nil, content: {
//                        VStack(alignment: .leading, spacing: -10 * scale, content: {
//                            Text("フレンドコード")
//                            HStack(spacing: 14, content: {
//                                Text(String(format: "SW-%@", account.friendCode))
//                                    .font(systemName: .Splatfont2, size: 14 * scale)
//                                Button(action: {
//                                    UIPasteboard.general.string = account.friendCode
//                                }, label: {
//                                    Image(systemName: .RectangleOnRectangleAngled)
//                                        .font(.system(size: 14 * scale, weight: .semibold, design: .monospaced))
//                                })
//                            })
//                            .foregroundColor(.secondary)
//                        })
//                        Spacer()
//                        Text("画像タップで切り替え")
//                            .underline()
//                    })
//                    .font(systemName: .Splatfont2, size: 16 * scale)
                })
            })
            .padding()
            .aspectRatio(300/120, contentMode: .fit)
            .backgroundCard(Color.whitesmoke, aspectRatio: 120/300)
            .halfsheet(
                isPresented: $isPresented,
                transitionStyle: .coverVertical,
                presentationStyle: .automatic,
                isModalInPresentation: false,
                detentIdentifier: .medium,
                prefersScrollingExpandsWhenScrolledToEdge: true,
                prefersEdgeAttachedInCompactHeight: true,
                detents: .medium,
                widthFollowsPreferredContentSizeWhenEdgeAttached: true,
                prefersGrabberVisible: true,
                onDismiss: {},
                content: {
                    AccountPickerView()
                        .environmentObject(service)
                })
        }
    }
    
    struct SplatNet2: View {
        @EnvironmentObject var service: LoadingService
        @State private var isPresented: Bool = false
        
        var body: some View {
            GeometryReader(content: { geometry in
                let scale: CGFloat = geometry.width / 120
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    Text("イカリング2")
                        .underline()
                })
                .position(geometry.center)
                .overlay(Image(systemName: .PlusCircle).foregroundColor(.blue).padding(scale * 10), alignment: .topTrailing)
                .backgroundView()
                .font(systemName: .Splatfont2, size: 16 * scale)
            })
            .scaledToFit()
            .authorize(isPresented: $isPresented, session: service.session)
        }
    }

    struct NewSalmonStats: View {
        @EnvironmentObject var service: LoadingService

        var body: some View {
            let color: Color = service.isFirestoreSignIn ? .blue : .clear
            GeometryReader(content: { geometry in
                let scale: CGFloat = geometry.width / 120
                Button(action: {
                    service.signInWithTwitterAccount()
                }, label: {
                    Text("Salmon Stats")
                        .underline()
                })
                .position(geometry.center)
                .overlay(Image(systemName: .CheckmarkSealFill).foregroundColor(color).padding(scale * 10), alignment: .topTrailing)
                .backgroundView()
                .font(systemName: .Splatfont2, size: 16 * scale)
            })
            .scaledToFit()
        }
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn.User()
            .environmentObject(LoadingService())
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 300, height: 120))
        SignIn.User()
            .environmentObject(LoadingService())
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 375, height: 150))
        SignIn.User()
            .environmentObject(LoadingService())
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 600, height: 240))
        SignIn.SplatNet2()
            .environmentObject(LoadingService())
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 120, height: 120))
        SignIn.SplatNet2()
            .environmentObject(LoadingService())
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 90, height: 90))
        SignIn.NewSalmonStats()
            .environmentObject(LoadingService())
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 120, height: 120))
    }
}
