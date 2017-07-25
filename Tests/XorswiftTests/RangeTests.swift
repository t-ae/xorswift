//
//  RangeTests.swift
//  Xorswift
//
//  Created by Araki on 2017/07/15.
//
//

import XCTest

class RangeTests: XCTestCase {

    func testRanges() {
        let max = UInt32.max
        let min = Float.leastNormalMagnitude
        let nextmax = nextafterf(Float(max), Float.infinity)
        
        XCTAssert(0 < 0/nextmax+min)
        XCTAssert(Float(max)/nextmax+min < 1)
    }

}
