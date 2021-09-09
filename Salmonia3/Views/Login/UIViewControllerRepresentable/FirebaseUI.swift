//
//  FirebaseUI.swift
//  Salmonia3
//
//  Created by Devonly on 3/13/21.
//

import Foundation
import SwiftUI
import FirebaseUI
import FirebaseAuth

struct FirebaseUI: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController

    class Coordinator: NSObject, FUIAuthDelegate {
        let parent: FirebaseUI
        init(_ parent: FirebaseUI) {
            self.parent = parent
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UINavigationController {
        let authUI = FUIAuth.defaultAuthUI()!
        let providers: [FUIAuthProvider] = [
            FUIAuth.twitterAuthProvider()
        ]
        authUI.providers = providers
        authUI.delegate = context.coordinator
        return authUI.authViewController()
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }
}
