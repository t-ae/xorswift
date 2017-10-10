
import XCTest
import Foundation
@testable import Xorswift

class NextAfterTests: XCTestCase {
    
    func testNextAfter() {
        do {
            let x: Float = 1213512
            XCTAssertEqual(Xorswift.nextafter(x, Float.infinity), Foundation.nextafter(x, Float.infinity))
        }
        do {
            let x: Double = 1213512
            XCTAssertEqual(Xorswift.nextafter(x, Double.infinity), Foundation.nextafter(x, Double.infinity))
        }
    }
    
}
