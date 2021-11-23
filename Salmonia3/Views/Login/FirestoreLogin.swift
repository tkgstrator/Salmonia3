//
//  FirestoreLogin.swift
//  Salmonia3
//
//  Created by devonly on 2021/11/23.
//

import SwiftUI
import FirebaseAuth

struct FirestoreLogin: View {
    let provider = OAuthProvider(providerID: "twitter.com").getCredentialWith(nil, completion: { credential, error in
        if let credential = credential {
            print(credential)
        }
    })
    var body: some View {
        Form(content: {
            Button(action: {}, label: {})
        })
    }
}

struct FirestoreLogin_Previews: PreviewProvider {
    static var previews: some View {
        FirestoreLogin()
    }
}
