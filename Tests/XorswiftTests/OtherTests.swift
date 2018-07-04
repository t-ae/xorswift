import XCTest
import Accelerate

class OtherTests: XCTestCase {
    func testDoubleMake() {
        let zero: UInt32 = 0
        let maxx: UInt32 = UInt32.max
        
        let minimum = Double(bitPattern: UInt64(zero<<12)<<20 | UInt64(zero) | 0x3ff0_0000_0000_0000) - 1
        XCTAssertEqual(minimum, 0)
        
        let maximum = Double(bitPattern: UInt64(maxx<<12)<<20 | UInt64(maxx) | 0x3ff0_0000_0000_0000) - 1
        XCTAssertLessThan(maximum, 1)
    }
    
    func testShiftOperation() {
        let ans = UInt32(1) << 31
        measure {
            for _ in 0..<100_000 {
                let a = UInt32(1) << 31
                XCTAssertEqual(a, ans)
            }
        }
    }
    
    func testMaskedShiftOperation() {
        let ans = UInt32(1) << 31
        measure {
            for _ in 0..<100_000 {
                let a = UInt32(1) &<< 31
                XCTAssertEqual(a, ans)
            }
        }
    }
}
