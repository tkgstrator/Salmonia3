//
//  GoogleMobileAds.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/23.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import GoogleMobileAds

internal struct UIGoogleMobileAdsView: UIViewControllerRepresentable {
    func makeCoordinator() -> () {
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        GADMobileAds.sharedInstance().start(completionHandler: nil)

        let view = GADBannerView(adSize: GADAdSizeBanner)
        let viewController = UIViewController()
#if DEBUG
        view.adUnitID = "ca-app-pub-7107468397673752/3033508550"
#else
        view.adUnitID = "ca-app-pub-7107468397673752/9251240303"
#endif
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
        view.load(GADRequest())
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

}

struct GoogleMobileAdsView: View {
    var body: some View {
        UIGoogleMobileAdsView()
            .frame(width: 320, height: 50)
    }
}

extension View {
    func withAdmobBanner(isAdDisabled: Bool) -> some View {
        return VStack(spacing: 0, content: {
            self
            isAdDisabled ? AnyView(EmptyView()) : AnyView(GoogleMobileAdsView())
        })
    }
}
