
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

extension OtherTests {
    func testDoubleMake() {
        let zero: UInt32 = 0
        let maxx: UInt32 = UInt32.max
        let multiplier = 1 / Double(UInt64(1)<<52)
        
        let minimum = Double(UInt64(zero<<12)<<20 & UInt64(zero)) * multiplier
        XCTAssertEqual(minimum, 0)
        
        let maximum = Double(UInt64(maxx<<12)<<20 & UInt64(maxx)) * multiplier
        XCTAssertLessThan(maximum, 1)
    }
}
