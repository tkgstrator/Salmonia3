//
//  Comparison.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/02.
//

import Foundation

extension StatsModel {
    class Comparison: StatsType {
        let id: UUID = UUID()
        let score: Float
        let other: Float
        let caption: String
        
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
    }
}
