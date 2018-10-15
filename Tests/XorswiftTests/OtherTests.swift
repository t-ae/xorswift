import XCTest

class OtherTests: XCTestCase {
    func testFloatMake() {
        let zero: UInt32 = 0
        let maxx: UInt32 = UInt32.max
        
        let minimum = Float(zero >> 8) * (.ulpOfOne / 2)
        XCTAssertEqual(minimum, 0)
        
        let maximum = Float(maxx >> 8) * (.ulpOfOne / 2)
        XCTAssertEqual(maximum, nextafter(1, 0))
    }
    
    func testDoubleMake() {
        let zero: UInt32 = 0
        let maxx: UInt32 = UInt32.max
        
        let minimum = Double(UInt64(zero<<11)<<21 | UInt64(zero)) * (.ulpOfOne / 2)
        XCTAssertEqual(minimum, 0)
        
        let maximum = Double(UInt64(maxx<<11)<<21 | UInt64(maxx)) * (.ulpOfOne / 2)
        XCTAssertEqual(maximum, nextafter(1, 0))
    }
    
    static let allTests = [
        ("testFloatMake", testFloatMake),
        ("testDoubleMake", testDoubleMake)
    ]
}
