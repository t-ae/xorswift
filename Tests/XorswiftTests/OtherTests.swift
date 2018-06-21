
import XCTest

class OtherTests: XCTestCase {

    func testRanges() {
        do {
            let max = UInt32.max
            let min = Float.leastNormalMagnitude
            let nextmax = nextafter(Float(max), Float.infinity)
            
            XCTAssertGreaterThan(0/nextmax+min, 0)
            XCTAssertLessThan(Float(max)/nextmax+min, 1)
            XCTAssertFalse(log(min).isNaN)
        }
        do {
            let max = UInt32.max
            let min = Double.leastNormalMagnitude
            let nextmax = nextafter(Double(max), Double.infinity)
            
            XCTAssertGreaterThan(0/nextmax+min, 0)
            XCTAssertLessThan(Double(max)/nextmax+min, 1)
            XCTAssertFalse(log(min).isNaN)
        }
    }

}
