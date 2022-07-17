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
import BetterSafariView
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
    struct Option: View {
        @State private var isPresented: Bool = false

        var body: some View {
            GeometryReader(content: { geometry in
                let scale: CGFloat = geometry.width / 120
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    ZStack(alignment: .bottom, content: {
                        Image(StickersType.judd)
                            .resizable()
                            .clipShape(Circle())
                        Text("設定")
                            .foregroundColor(.primary)
                            .shadow(color: .blue, radius: 1, x: 1, y: 1)
                    })
                    .background(Circle())
                })
                .font(systemName: .Splatfont2, size: 20 * scale)
            })
            .overlay(NavigationLink(destination: SettingView(), isActive: $isPresented, label: { EmptyView() }))
            .overlay(Circle().strokeBorder(lineWidth: 4, antialiased: true))
            .scaledToFit()
            .frame(maxWidth: 100)
        }
    }

    struct Product: View {
        @State private var isPresented: Bool = false

        var body: some View {
            GeometryReader(content: { geometry in
                let scale: CGFloat = geometry.width / 120
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    ZStack(alignment: .bottom, content: {
                        Image(StickersType.snail)
                            .resizable()
                            .clipShape(Circle())
                        Text("機能を追加")
                            .foregroundColor(.primary)
                            .shadow(color: .blue, radius: 1, x: 1, y: 1)
                    })
                    .background(Circle())
                })
                .font(systemName: .Splatfont2, size: 20 * scale)
            })
            .overlay(NavigationLink(destination: ProductView().environmentObject(StoreKitService()), isActive: $isPresented, label: { EmptyView() }))
            .overlay(Circle().strokeBorder(lineWidth: 4, antialiased: true))
            .scaledToFit()
            .frame(maxWidth: 100)
        }
    }

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
            GeometryReader(content: { geometry in
                let scale: CGFloat = geometry.width / 120
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    ZStack(alignment: .bottom, content: {
                        WebImage(url: account.thumbnailURL)
                            .resizable()
                            .clipShape(Circle())
                        Text(account.nickname)
                            .foregroundColor(.primary)
                            .shadow(color: .blue, radius: 1, x: 1, y: 1)
                    })
                    .background(Circle())
                })
                .font(systemName: .Splatfont2, size: 20 * scale)
            })
            .scaledToFit()
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
            .overlay(Circle().strokeBorder(lineWidth: 4, antialiased: true))
            .frame(maxWidth: 100)
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
                    ZStack(alignment: .bottom, content: {
                        Image(StickersType.inkling)
                            .resizable()
                            .clipShape(Circle())
                        Text("アカウント追加")
                            .foregroundColor(.primary)
                            .shadow(color: .blue, radius: 1, x: 1, y: 1)
                    })
                    .background(Circle())
                })
                .font(systemName: .Splatfont2, size: 20 * scale)
            })
            .scaledToFit()
            .overlay(Circle().strokeBorder(lineWidth: 4, antialiased: true))
            .authorize(isPresented: $isPresented, session: service.session)
            .frame(maxWidth: 100)
        }
    }

    struct NewSalmonStats: View {
        @EnvironmentObject var service: LoadingService

        var body: some View {
            GeometryReader(content: { geometry in
                let scale: CGFloat = geometry.width / 120
                Button(action: {
                    service.signInWithTwitterAccount()
                }, label: {
                    ZStack(alignment: .bottom, content: {
                        Image(StickersType.stats)
                            .resizable()
                            .clipShape(Circle())
                        Text("Statsと連携")
                            .foregroundColor(.primary)
                            .shadow(color: .blue, radius: 1, x: 1, y: 1)
                    })
                    .background(Circle())
                })
                .font(systemName: .Splatfont2, size: 20 * scale)
            })
            .scaledToFit()
            .overlay(Circle().strokeBorder(lineWidth: 4, antialiased: true))
            .frame(maxWidth: 100)
        }
    }

    struct SalmonStats: View {
        @State private var isPresented: Bool = false

        var body: some View {
            GeometryReader(content: { geometry in
                let scale: CGFloat = geometry.width / 120
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    ZStack(alignment: .bottom, content: {
                        Image(StickersType.stats)
                            .resizable()
                            .clipShape(Circle())
                        Text("Salmon Stats")
                            .foregroundColor(.primary)
                            .shadow(color: .blue, radius: 1, x: 1, y: 1)
                    })
                    .background(Circle())
                })
                .font(systemName: .Splatfont2, size: 20 * scale)
            })
            .scaledToFit()
            .safariView(isPresented: $isPresented) {
                SafariView(
                    url: URL(string: "https://salmonstats.splatnet2.com/results")!,
                    configuration: SafariView.Configuration(
                        entersReaderIfAvailable: false,
                        barCollapsingEnabled: true
                    )
                )
                .preferredBarAccentColor(.clear)
                .preferredControlAccentColor(.accentColor)
                .dismissButtonStyle(.done)
            }
            .overlay(Circle().strokeBorder(lineWidth: 4, antialiased: true))
            .frame(maxWidth: 100)
        }
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn.NewSalmonStats()
            .environmentObject(LoadingService())
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 120, height: 120))
        SignIn.Product()
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 120, height: 120))
        SignIn.Option()
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 120, height: 120))
        SignIn.SalmonStats()
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 120, height: 120))
        SignIn.SplatNet2()
            .environmentObject(LoadingService())
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 120, height: 120))
    }
}
