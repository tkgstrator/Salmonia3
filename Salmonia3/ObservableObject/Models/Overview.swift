//
//  Overview.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/02.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation

extension StatsModel {
    class Overview: StatsScoreType {
        let id: UUID = UUID()
        let score: Float
        let other: Float
        let caption: String
        
        internal init<T: BinaryFloatingPoint>(score: T?, other: T?, caption: String) {
            self.caption = caption
            self.score = {
                guard let score = score else {
                    return .zero
                }
                return Float(score)
            }()
            self.other = {
                guard let other = other else {
                    return .zero
                }
                return Float(other)
            }()
        }
        
        internal init<T: BinaryInteger>(score: T?, other: T?, caption: String) {
            self.caption = caption
            self.score = {
                guard let score = score else {
                    return .zero
                }
                return Float(score)
            }()
            self.other = {
                guard let other = other else {
                    return .zero
                }
                return Float(other)
            }()
        }
    }
}
