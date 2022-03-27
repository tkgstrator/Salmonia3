//
//  LoginService.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/27.
//  
//

import Foundation
import SplatNet2
import Combine
import Common
import Alamofire

final class LoginService: ObservableObject, SplatNet2SessionDelegate {
    internal let session: SplatNet2
    @Published var current: Int = .zero
    @Published var maximum: Int = 8
    @Published var isPresented: Bool = false
    
    init() {
        self.session = SplatNet2(refreshable: true)
        self.session.delegate = self
    }

    func willReceiveSubscription(subscribe: Subscription) {
    }
    
    func willReceiveOutput(output: Decodable & Encodable) {
    }
    
    func willReceiveCompletion(completion: Subscribers.Completion<AFError>) {
    }
    
    func willReceiveCancel() {
    }
    
    func willReceiveRequest(request: Subscribers.Demand) {
    }
    
    func progressSignIn(state: SignInState) {
        DispatchQueue.main.async(execute: {
            self.current = state.progress
            print(state.id, state.progress)
            self.objectWillChange.send()
        })
    }
    
    func isAvailableResults(current: Int, maximum: Int) {
    }
    
    func isGettingResultId(current: Int) {
    }
    
    func willRunningSplatNet2SignIn() {
        DispatchQueue.main.async(execute: {
            self.isPresented = true
        })
    }
    
    func didFinishSplatNet2SignIn(account: UserInfo) {
        NotificationCenter.default.post(name: .didFinishedLogin, object: nil)
    }
    
    func failedWithUnavailableVersion(version: String) {
    }
    
    func failedWithSP2Error(error: SP2Error) {
        NotificationCenter.default.post(name: .didFinishedLogin, object: error)
    }
}
