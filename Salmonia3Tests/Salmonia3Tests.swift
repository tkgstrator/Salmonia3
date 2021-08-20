//
//  Salmonia3Tests.swift
//  Salmonia3Tests
//
//  Created by tkgstrator on 2021/03/11.
//

import XCTest
@testable import Salmonia3

class Salmonia3Tests: XCTestCase {

    func testShiftStartTime() throws {
        print(RealmManager.shared.latestShiftStartTime)
    }

}
