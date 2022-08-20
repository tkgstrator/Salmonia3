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
import StoreKit

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
    struct NavIcon<Content: View>: View {
        let action: () -> Void
        let label: () -> Content
        let loaclizedText: Text
        let scale: CGFloat

        init(localizedText: Text, scale: CGFloat? = nil, action: @escaping () -> Void, label: @escaping () -> Content) {
            self.loaclizedText = localizedText
            self.action = action
            self.label = label
            self.scale = scale ?? 1.0
        }

        var body: some View {
            GeometryReader(content: { geometry in
                VStack(content: {
                    let scale: CGFloat = geometry.width / 120
                    Button(action: {
                        action()
                    }, label: {
                        label()
                            .clipShape(Circle())
                            .background(Circle())
                            .scaledToFit()
                    })
                    .font(systemName: .Splatfont2, size: 20 * scale)
                    .overlay(Circle().strokeBorder(lineWidth: 4, antialiased: true))
                    loaclizedText
                        .foregroundColor(.primary)
                        .font(systemName: .Splatfont2, size: 16 * scale)
                        .frame(height: 20 * scale)
                })
                .position(geometry.center)
            })
            .scaledToFit()
        }
    }

    struct WriteReview: View {
        var body: some View {
            SignIn.NavIcon(
                localizedText: Text("レビューを書く"),
                action: {
                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        SKStoreReviewController.requestReview(in: scene)
                    }
                }, label: {
                    Image(systemName: .PencilAndOutline)
                        .resizable()
                        .foregroundColor(.white)
                })
        }
    }

    struct LightSwitch: View {
        @EnvironmentObject var service: AppService

        var body: some View {
            SignIn.NavIcon(
                localizedText: Text("外観切り替え"),
                action: {
                    $service.apperances.isDarkmode.wrappedValue.toggle()
                }, label: {
                    Image(systemName: .Switch2)
                        .resizable()
                        .foregroundColor(.white)
                })
        }
    }

    struct Option: View {
        @State private var isPresented: Bool = false

        var body: some View {
            SignIn.NavIcon(
                localizedText: Text("設定"),
                action: {
                    isPresented.toggle()
                }, label: {
                    Image(StickersType.judd)
                        .resizable()
                        .padding(10)
                })
            .overlay(NavigationLink(destination: SettingView(), isActive: $isPresented, label: { EmptyView() }))
        }
    }

    struct Product: View {
        @EnvironmentObject var service: AppService
        @State private var isPresented: Bool = false

        var body: some View {
            SignIn.NavIcon(
                localizedText: Text("機能の追加"),
                action: {
                    isPresented.toggle()
                }, label: {
                    Image(StickersType.snail)
                        .resizable()
                        .padding(0)
                })
            .overlay(NavigationLink(destination: ProductView().environmentObject(service.storekit), isActive: $isPresented, label: { EmptyView() }))
        }
    }

    struct User: View {
        @EnvironmentObject var service: LoadingService
        @State private var isPresented: Bool = false
        @AppStorage("work.tkgstrator.multiaccounts") var isMultiEnabled: Bool = false

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
                        nickname: "未ログイン"
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
            SignIn.NavIcon(
                localizedText: Text(account.nickname),
                action: {
                    if isMultiEnabled {
                        isPresented.toggle()
                    }
                }, label: {
                    WebImage(url: account.thumbnailURL)
                        .resizable()
                        .foregroundColor(.white)
                })
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
            SignIn.NavIcon(
                localizedText: Text("アカウント追加"),
                action: {
                    isPresented.toggle()
                }, label: {
                    Image(StickersType.inkling)
                        .resizable()
                        .padding(4)
                })
            .authorize(isPresented: $isPresented, session: service.session)
        }
    }

    struct Twitter: View {
        @EnvironmentObject var service: LoadingService

        var body: some View {
            SignIn.NavIcon(
                localizedText: Text("Twitter連携"),
                action: {
                    service.signInWithTwitterAccount()
                }, label: {
                    Image(StickersType.twitter)
                        .resizable()
                        .padding(4)
                })
        }
    }

    struct SalmonStats: View {
        @State private var isPresented: Bool = false

        var body: some View {
            SignIn.NavIcon(
                localizedText: Text("Salmon Stats"),
                action: {
                    isPresented.toggle()
                }, label: {
                    Image(StickersType.stats)
                        .resizable()
                })
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
        }
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn.User()
            .environmentObject(LoadingService())
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 120, height: 120))
        SignIn.WriteReview()
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 120, height: 120))
        SignIn.Twitter()
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
        SignIn.LightSwitch()
            .environmentObject(AppService())
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 120, height: 120))
        SignIn.SplatNet2()
            .environmentObject(LoadingService())
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 120, height: 120))
    }
}
