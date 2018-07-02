import XCTest
import Xorswift

class XorshiftGeneratorTests: XCTestCase {
    
    func testFill() {
        let count = 10000
        var array = [UInt32](repeating: 0, count: count)
        XorshiftGenerator.default.fill(&array)
        XCTAssertEqual(Set(array).count, count)
    }

    func testCoW() {
        var gen = XorshiftGenerator.default
        var gen2 = gen
        
        XCTAssertEqual(gen.next() as UInt8, gen2.next() as UInt8)
        XCTAssertEqual(gen.next() as UInt16, gen2.next() as UInt16)
        XCTAssertEqual(gen.next() as UInt32, gen2.next() as UInt32)
        XCTAssertEqual(gen.next() as UInt64, gen2.next() as UInt64)
    }
}
