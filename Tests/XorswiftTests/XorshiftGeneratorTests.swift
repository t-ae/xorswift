import XCTest
import Xorswift

class XorshiftGeneratorTests: XCTestCase {

    func testCoW() {
        var gen = XorshiftGenerator()
        var gen2 = gen
        
        XCTAssertEqual(gen.next(), gen2.next() as UInt8)
        XCTAssertEqual(gen.next(), gen2.next() as UInt16)
        XCTAssertEqual(gen.next(), gen2.next() as UInt32)
        XCTAssertEqual(gen.next(), gen2.next() as UInt64)
        
        XCTAssertEqual(Int.random(in: 0..<10, using: &gen), Int.random(in: 0..<10, using: &gen2))
        XCTAssertEqual(UInt.random(in: 0..<10, using: &gen), UInt.random(in: 0..<10, using: &gen2))
        XCTAssertEqual(Float.random(in: 0..<10, using: &gen), Float.random(in: 0..<10, using: &gen2))
        XCTAssertEqual(Double.random(in: 0..<10, using: &gen), Double.random(in: 0..<10, using: &gen2))
        
        XCTAssertEqual(gen.generateUniform(count: 10), gen2.generateUniform(count: 10) as [Float])
        XCTAssertEqual(gen.generateUniform(count: 10), gen2.generateUniform(count: 10) as [Double])
        XCTAssertEqual(gen.generateNormal(count: 10), gen2.generateNormal(count: 10) as [Float])
        XCTAssertEqual(gen.generateNormal(count: 10), gen2.generateNormal(count: 10) as [Double])
        
        var a1 = [Float](repeating: 0, count: 10)
        var a2 = [Float](repeating: 0, count: 10)
        gen.fillNormal_no_accelerate(start: &a1, count: 10)
        gen2.fillNormal_no_accelerate(start: &a2, count: 10)
        XCTAssertEqual(a1, a2)
    }
    
    static let allTests = [
        ("testCoW", testCoW)
    ]
}
