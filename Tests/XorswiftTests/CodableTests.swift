import XCTest
import Xorswift

class CodableTests: XCTestCase {
    
    func testCodable() throws {
        var rng = XorshiftGenerator()
        
        let encoded = try JSONEncoder().encode(rng)
        var decoded = try JSONDecoder().decode(XorshiftGenerator.self, from: encoded)
        
        XCTAssertEqual(decoded.next(), rng.next() as UInt32)
        XCTAssertEqual(decoded.next(), rng.next() as UInt32)
        XCTAssertEqual(decoded.next(), rng.next() as UInt32)
        XCTAssertEqual(decoded.next(), rng.next() as UInt32)
        XCTAssertEqual(decoded.next(), rng.next() as UInt32)
    }

    static let allTests = [
        ("testCodable", testCodable)
    ]
}
