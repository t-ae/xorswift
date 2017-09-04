
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
