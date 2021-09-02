//
//  LotteryManager.swift
//  Salmonia3
//
//  Created by devonly on 2021/08/22.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI
import CryptoKit

final class LotteryManager {
    
    static let shared: LotteryManager = LotteryManager()
    
    private init() {}

    /// 自分のID, シフトID, マッチングしたプレイヤーのIDからくじを生成する
    func generate(startTime: Int, pids: [String]) {
        // シフト時間からアタリ番号を計算（全員が同じ番号になるようにする）
        let lotteryIds: [String] = pids.map({ md5HashToInt(from: $0, key: startTime) })
    }
    
    @usableFromInline
    internal func md5HashToInt(from: String, key: Int) -> String {
        let base: String = [String(key), UIDevice.current.identifierForVendor!.uuidString, from].joined()
        let hash = Insecure.MD5.hash(data: base.data(using: .utf8)!).compactMap({ String(format: "%02x", $0) }).joined()
        let hashSubstring: String = String(hash.prefix(4))
        return "\(hash.prefix(1).uppercased())-\(String(format: "%05d", Int(hashSubstring, radix: 16)!))"
    }
}

