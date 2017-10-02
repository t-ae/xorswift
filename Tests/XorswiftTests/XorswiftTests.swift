import XCTest
import Foundation
@testable import Xorswift

class XorswiftTests: XCTestCase {
    
    func testXorshift() {
        do {
            let count = 0
            var a = [UInt32](repeating: 0, count: count)
            
            xorshift(start: &a, count: count)
            
            XCTAssertEqual(a, [])
        }
        do {
            let count = 1
            var a = [UInt32](repeating: 0, count: count)
            
            xorshift(start: &a, count: count)
            
            XCTAssertEqual(a.count, 1)
        }
    }
    
    func testXorshift_uniform() {
        do {
            let count = 1_000_000
            var a = [Float](repeating: 0, count: count)
            
            xorshift_uniform(start: &a, count: count, low: 1, high: 2)
            let mean = a.reduce(0, +) / Float(a.count)
            
            XCTAssertEqual(mean, 1.5, accuracy: 1e-3)
            XCTAssert(a.min()! >= 1)
            XCTAssert(a.max()! < 2)
        }
        do {
            let count = 1_000_002
            
            let a: [Float] = xorshift_uniform(count: count, low: 1, high: 2)
            let mean = a.reduce(0, +) / Float(a.count)
            
            XCTAssertEqual(mean, 1.5, accuracy: 1e-3)
            XCTAssert(a.min()! >= 1)
            XCTAssert(a.max()! < 2)
        }
        do {
            let count = 0
            var a = [Float](repeating: 0, count: count)
            
            xorshift_uniform(start: &a, count: count, low: -1, high: 1)
            
            XCTAssertEqual(a, [])
        }
    }
    
    func testXorshift_normal() {
        do {
            let count = 1_000_000
            var a = [Float](repeating: 0, count: count)
            
            xorshift_normal(start: &a, count: count, mu: -1, sigma: 0.5)
            
            let mean = a.reduce(0, +) / Float(a.count)
            let mean2: Float = a.map { $0*$0 }.reduce(0, +) / Float(a.count)
            let variance = mean2 - mean*mean
            
            XCTAssertEqual(mean, -1, accuracy: 1e-2)
            XCTAssertEqual(variance, 0.5*0.5, accuracy: 1e-2)
        }
        do {
            let count = 1_000_001
            
            let a: [Float] = xorshift_normal(count: count, mu: -1, sigma: 0.5)
            
            let mean = a.reduce(0, +) / Float(a.count)
            let mean2: Float = a.map { $0*$0 }.reduce(0, +) / Float(a.count)
            let variance = mean2 - mean*mean
            
            XCTAssertEqual(mean, -1, accuracy: 1e-2)
            XCTAssertEqual(variance, 0.5*0.5, accuracy: 1e-2)
        }
        do {
            let count = 1_001
            var a = [Float](repeating: -1, count: count)
            
            xorshift_normal(start: &a, count: count, mu: 1, sigma: 0)
            
            XCTAssertEqual(a, [Float](repeating: 1, count: count))
        }
        do {
            let count = 0
            var a = [Float](repeating: 0, count: count)
            
            xorshift_normal(start: &a, count: count, mu: 0, sigma: 1)
            
            XCTAssertEqual(a, [])
        }
        
        // _xorshift_normal
        do {
            let count = 1_000_000
            var a = [Float](repeating: 0, count: count)
            
            _xorshift_normal(start: &a, count: count, mu: -1, sigma: 0.5)
            
            let mean = a.reduce(0, +) / Float(a.count)
            let mean2: Float = a.map { $0*$0 }.reduce(0, +) / Float(a.count)
            let variance = mean2 - mean*mean
            
            XCTAssertEqual(mean, -1, accuracy: 1e-2)
            XCTAssertEqual(variance, 0.5*0.5, accuracy: 1e-2)
        }
        do {
            let count = 1_001
            var a = [Float](repeating: -1, count: count)
            
            _xorshift_normal(start: &a, count: count, mu: 1, sigma: 0)
            
            XCTAssertEqual(a, [Float](repeating: 1, count: count))
        }
        do {
            let count = 0
            var a = [Float](repeating: 0, count: count)
            
            _xorshift_normal(start: &a, count: count, mu: 0, sigma: 1)
            
            XCTAssertEqual(a, [])
        }
    }
}
