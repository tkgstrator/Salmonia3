//
//  GoogleMobileAds.swift
//  Salmonia3
//
//  Created by Devonly on 3/20/21.
//

import Foundation
import SwiftUI
import UIKit
import GoogleMobileAds

struct UIGoogleMobileAdsView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        GADMobileAds.sharedInstance().start(completionHandler: nil)

        let view = GADBannerView(adSize: kGADAdSizeBanner)
        let viewController = UIViewController()
        #if DEBUG
        view.adUnitID = "ca-app-pub-7107468397673752/4904180382"
        #else
        view.adUnitID = "ca-app-pub-7107468397673752/3033508550"
        #endif
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeBanner.size)
        view.load(GADRequest())
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

}

struct GoobleMobileAdsView: View {
    var body: some View {
        UIGoogleMobileAdsView()
            .frame(width: 320, height: 50)
    }
}
