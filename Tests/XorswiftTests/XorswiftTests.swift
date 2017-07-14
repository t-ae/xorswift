import XCTest
import Foundation
@testable import Xorswift

class XorswiftTests: XCTestCase {
    
    func testXorshift_float() {
        let count = 1_000_000
        var a = [Float](repeating: 0, count: count)
        
        xorshift_uniform(start: &a, count: count, low: 0, high: 1)
        let mean = a.reduce(0, +) / Float(a.count)
        
        XCTAssertEqualWithAccuracy(mean, 0.5, accuracy: 1e-3)
    }
    
    func testXorshift_normal() {
        let count = 1_000_000
        var a = [Float](repeating: 0, count: count)
        
        xorshift_normal(start: &a, count: count, mu: 0, sigma: 1)
        
        let mean = a.reduce(0, +) / Float(a.count)
        let variance = (a.map { $0*$0 }.reduce(0, +) - mean*mean) / Float(a.count)
        
        XCTAssertEqualWithAccuracy(mean, 0, accuracy: 1e-2)
        XCTAssertEqualWithAccuracy(variance, 1, accuracy: 1e-2)
    }
}
