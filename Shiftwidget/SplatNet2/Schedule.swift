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
    let startTime: Int
    let endTime: Int
    let rareWeapon: Int?
    let weaponList: [Int]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.stageId = try container.decode(Int.self, forKey: .stageId)
        self.startTime = try container.decode(Int.self, forKey: .startTime)
        self.endTime = try container.decode(Int.self, forKey: .endTime)
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
                // JSONを読み込んでSchedule型に変換する
                self.schedules = try decoder.decode([Schedule].self, from: data)
                // 現在時刻以降の時間を取得
                self.schedulesTime = schedules.flatMap({ [$0.startTime, $0.endTime] }).filter({ $0 > Int(Date().timeIntervalSince1970) }).sorted().map({ Date(timeIntervalSince1970: Double($0)) })
            } else {
                fatalError()
            }
        } catch {
            fatalError()
        }
    }
    
}
