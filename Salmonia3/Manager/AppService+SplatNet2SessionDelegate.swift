//
//  AppService+SplatNet2SessionDelegate.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/12.
//

import Foundation
import SplatNet2
import Combine
import Alamofire
import CocoaLumberjackSwift
import Common
import SwiftUI

extension AppService: SplatNet2SessionDelegate {
    func didFinishSplatNet2SignIn(account: UserInfo) {
        DispatchQueue.main.async(execute: {
            self.account = account
            self.isSignIn.toggle()
        })
    }
    
    func willRunningSplatNet2SignIn() {
        DispatchQueue.main.async(execute: {
            withAnimation(.default) {
                self.isSignIn.toggle()
            }
        })
    }
    
    func failedWithSP2Error(error: SP2Error) {
        DDLogError(error)
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
            withAnimation(.default) {
                self.signInState = state
            }
        })
    }
    
    func isAvailableResults(current: Int, maximum: Int) {
    }
    
    func didFinishSplatNet2SignIn() {
    }
    
    func failedWithUnavailableVersion(version: String) {
    }
}
