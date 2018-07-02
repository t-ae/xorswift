import XCTest
import Xorswift

class XorshiftGeneratorTests: XCTestCase {

    func testCoW() {
        var gen = XorshiftGenerator.default
        var gen2 = gen
        
        XCTAssertEqual(gen.next(), gen2.next() as UInt8)
        XCTAssertEqual(gen.next(), gen2.next() as UInt16)
        XCTAssertEqual(gen.next(), gen2.next() as UInt32)
        XCTAssertEqual(gen.next(), gen2.next() as UInt64)
        
        XCTAssertEqual(gen.uniform.next(), gen2.uniform.next() as Float)
        XCTAssertEqual(gen.uniform.next(), gen2.uniform.next() as Double)
        XCTAssertEqual(gen.normal.next(), gen2.normal.next() as Float)
        XCTAssertEqual(gen.normal.next(), gen2.normal.next() as Double)
        
        XCTAssertEqual(gen.uniform.generate(count: 10), gen2.uniform.generate(count: 10) as [Float])
        XCTAssertEqual(gen.uniform.generate(count: 10), gen2.uniform.generate(count: 10) as [Double])
        XCTAssertEqual(gen.normal.generate(count: 10), gen2.normal.generate(count: 10) as [Float])
        XCTAssertEqual(gen.normal.generate(count: 10), gen2.normal.generate(count: 10) as [Double])
    }
}
