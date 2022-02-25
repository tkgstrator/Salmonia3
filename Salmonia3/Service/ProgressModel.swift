//
//  ProgressModel.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/24.
//

import Foundation

struct ProgressModel {
    var current: Int {
        willSet {
            self.progressValue = Double(self.totalCount - (self.maximum - newValue)) / Double(self.totalCount)
        }
    }
    var maximum: Int
    var totalCount: Int
    var progressValue: Double = 0.0
    
    internal init(current: Int, maximum: Int, totalCount: Int) {
        self.current = current
        self.maximum = maximum
        self.totalCount = totalCount
    }
}
