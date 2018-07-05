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
        
        XCTAssertEqual(gen.uniform.next(in: 0..<1), gen2.uniform.next(in: 0..<1) as Float)
        XCTAssertEqual(gen.uniform.next(in: 0..<1), gen2.uniform.next(in: 0..<1) as Double)
        XCTAssertEqual(gen.normal.next(mu: 0, sigma: 1), gen2.normal.next(mu: 0, sigma: 1) as Float)
        XCTAssertEqual(gen.normal.next(mu: 0, sigma: 1), gen2.normal.next(mu: 0, sigma: 1) as Double)
        
        XCTAssertEqual(gen.uniform.generate(count: 10), gen2.uniform.generate(count: 10) as [Float])
        XCTAssertEqual(gen.uniform.generate(count: 10), gen2.uniform.generate(count: 10) as [Double])
        XCTAssertEqual(gen.normal.generate(count: 10), gen2.normal.generate(count: 10) as [Float])
        XCTAssertEqual(gen.normal.generate(count: 10), gen2.normal.generate(count: 10) as [Double])
        
        var a1 = [Float](repeating: 0, count: 10)
        var a2 = [Float](repeating: 0, count: 10)
        gen.normal.fill_no_accelerate(start: &a1, count: 10)
        gen2.normal.fill_no_accelerate(start: &a2, count: 10)
        XCTAssertEqual(a1, a2)
    }
    
    static let allTests = [
        ("testCoW", testCoW)
    ]
}
