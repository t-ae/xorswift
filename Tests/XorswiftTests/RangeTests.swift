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
        let max = UINT32_MAX
        let min = Float.leastNonzeroMagnitude
        let nextmax = nextafterf(Float(max), Float(UINT64_MAX))
        
        XCTAssert(0 < 0/nextmax+min)
        XCTAssert(Float(max)/nextmax+min < 1)
    }

}
