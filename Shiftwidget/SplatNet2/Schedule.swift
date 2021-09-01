//
//  Schedule.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/01.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents
import Foundation

public final class Schedule: Codable {
    let stageId: Int
    let startTime: Date
    let endTime: Date
    let rareWeapon: Int?
    let weaponList: [Int]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.stageId = try container.decode(Int.self, forKey: .stageId)
        self.startTime = Date(timeIntervalSince1970: Double(try container.decode(Int.self, forKey: .startTime)))
        self.endTime = Date(timeIntervalSince1970: Double(try container.decode(Int.self, forKey: .endTime)))
        self.weaponList = try container.decode([Int].self, forKey: .weaponList)
        if self.weaponList.contains(-1) {
            self.rareWeapon = try container.decode(Int.self, forKey: .rareWeapon)
        } else {
            self.rareWeapon = nil
        }
    }
}

public final class WidgetManager {
    
    static let shared: WidgetManager = WidgetManager()
    let schedules: [Schedule]
    let schedulesTime: [Date]
    
    public init() {
        do {
            if let json = Bundle.main.url(forResource: "coop", withExtension: "json") {
                let data = try Data(contentsOf: json)
                let decoder: JSONDecoder = {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    return decoder
                }()
                // 現在時刻
                let currentTime: Date = Date()
                // 終了時間が現在時間よりもあとのものを表示
                // JSONを読み込んでSchedule型に変換する
                self.schedules = try decoder.decode([Schedule].self, from: data).filter({ $0.endTime > currentTime })
                // ビューを更新する時間を取得
                self.schedulesTime = schedules.map({ $0.startTime })
            } else {
                fatalError()
            }
        } catch {
            fatalError()
        }
    }
    
}
