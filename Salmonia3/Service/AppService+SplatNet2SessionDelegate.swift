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
import SalmonStats

extension AppService: SalmonStatsSessionDelegate {
    /// リザルト読み込みが終わったときに呼ばれる
    func didFinishLoadResultsFromSplatNet2(results: [(id: Int, status: UploadStatus, result: CoopResult.Response)]) {
        /// Firestoreに書き込み
        if let user = user {
            register(results: results.map({ $0.result }))
        }
        /// リザルトを書き込み
        self.save(results: results)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            self.isLoading.toggle()
        })
    }
    
    /// 取得中のリザルトIDを返す
    func isGettingResultId(current: Int) {
        DispatchQueue.main.async(execute: {
            withAnimation(.default) {
                self.progress?.current = current
            }
        })
    }
    
    /// ログインが完了したときに呼ばれる
    func didFinishSplatNet2SignIn(account: UserInfo) {
        DispatchQueue.main.async(execute: {
            // アカウント情報を上書きして、モーダルを閉じる
            self.account = account
            self.isSignIn = false
        })
    }
    
    /// ログインが始まったときに呼ばれる
    func willRunningSplatNet2SignIn() {
        DispatchQueue.main.async(execute: {
            withAnimation(.default) {
                self.isSignIn = true
            }
        })
    }
    
    /// エラーが発生したときに呼ばれる
    func failedWithSP2Error(error: SP2Error) {
        DispatchQueue.main.async(execute: {
            self.sp2Error = error
        })
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
    
    /// サインインの状況を返す
    func progressSignIn(state: SignInState) {
        DispatchQueue.main.async(execute: {
            withAnimation(.default) {
                self.signInState = state
            }
        })
    }
    
    /// 取得可能なリザルトIDを返す
    func isAvailableResults(current: Int, maximum: Int) {
        DispatchQueue.main.async(execute: {
            withAnimation(.default) {
                self.progress = ProgressModel(current: current, maximum: maximum, totalCount: maximum - current + 1)
            }
        })
    }
    
    func failedWithUnavailableVersion(version: String) {
    
    }
}
