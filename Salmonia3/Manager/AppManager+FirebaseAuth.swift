//
//  AppManager+FirebaseAuth.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/31.
//

import Foundation
import FirebaseAuth
import FirebaseAuthCombineSwift
import Combine

extension AppManager {
    /// Twitterログイン
    internal func twitterSignin() -> AnyPublisher<String, Error> {
        Future { [self] promise in
            provider.getCredentialWith(nil, completion: { credential, error in
                if let error = error {
                    promise(.failure(error))
                }
                
                if let credential = credential {
                    Auth.auth().signIn(with: credential, completion: { result, error in
                        if let error = error {
                            promise(.failure(error))
                        }
                        if let result = result, let userName = result.user.displayName {
                            promise(.success(userName))
                        }
                    })
                }
            })
        }
        .eraseToAnyPublisher()
    }
}
