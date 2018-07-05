import XCTest

class OtherTests: XCTestCase {
    func testFloatMake() {
        let zero: UInt32 = 0
        let maxx: UInt32 = UInt32.max
        
        let ranges: [Range<Float>] = [0..<1, 1..<2, 2..<4]
        for range in ranges {
            let delta = range.upperBound - range.lowerBound
            
            let minimum = Float(bitPattern: zero >> 9 | 0x3f80_0000)
            XCTAssertEqual(minimum, 1)
            let lb = delta * (minimum - 1) + range.lowerBound
            XCTAssertEqual(lb, range.lowerBound)
            
            let maximum = Float(bitPattern: maxx >> 9 | 0x3f80_0000)
            XCTAssertEqual(maximum, nextafter(2, 0))
            let ub = delta * (maximum - 1) + range.lowerBound
            XCTAssertLessThan(ub, range.upperBound)
        }
    }
    
    func testDoubleMake() {
        let zero: UInt32 = 0
        let maxx: UInt32 = UInt32.max
        
        let minimum = Double(bitPattern: UInt64(zero<<12)<<20 | UInt64(zero) | 0x3ff0_0000_0000_0000)
        XCTAssertEqual(minimum, 1)
        
        let maximum = Double(bitPattern: UInt64(maxx<<12)<<20 | UInt64(maxx) | 0x3ff0_0000_0000_0000)
        XCTAssertEqual(maximum, nextafter(2, 0))
    }
    
    static let allTests = [
        ("testFloatMake", testFloatMake),
        ("testDoubleMake", testDoubleMake)
    ]
}
