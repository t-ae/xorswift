import XCTest
import Foundation
import Xorswift

class XorswiftTests: XCTestCase {
    func testXorshift() {
        do {
            let count = 0
            var a = [UInt32](repeating: 0, count: count)
            XorshiftGenerator.default.fill(&a)
            
            XCTAssertEqual(a, [])
        }
        do {
            let ub = UInt32(10)
            let a = (0..<10000).map { _ in XorshiftGenerator.default.next(upperBound: ub) }
            
            XCTAssertEqual(Set(a).count, 10)
        }
    }
    
    func testXorshift_uniform_float_single() {
        typealias T = Float
        do {
            let count = 1_000_001
            let a: [T] = (0..<count).map { _ in XorshiftGenerator.default.uniform.next() }
            
            let mean = a.reduce(0, +) / T(a.count)
            
            XCTAssertEqual(mean, 0.5, accuracy: 1e-3)
            XCTAssertGreaterThanOrEqual(a.min()!, 0)
            XCTAssertLessThan(a.max()!, 1)
        }
    }
    
    func testXorshift_uniform_double_single() {
        typealias T = Double
        do {
            let count = 1_000_001
            let a: [T] = (0..<count).map { _ in XorshiftGenerator.default.uniform.next() }
            
            let mean = a.reduce(0, +) / T(a.count)
            
            XCTAssertEqual(mean, 0.5, accuracy: 1e-3)
            XCTAssertGreaterThanOrEqual(a.min()!, 0)
            XCTAssertLessThan(a.max()!, 1)
        }
    }
    
    func testXorshift_uniform_float() {
        typealias T = Float
        do {
            let count = 1_000_001
            var a = [T](repeating: 0, count: count)
            
            XorshiftGenerator.default.uniform.fill(start: &a, count: count)
            let mean = a.reduce(0, +) / T(a.count)
            
            XCTAssertEqual(mean, 0.5, accuracy: 1e-3)
            XCTAssertGreaterThanOrEqual(a.min()!, 0)
            XCTAssertLessThan(a.max()!, 1)
        }
        do {
            let count = 1_000_002
            var a = [T](repeating: 0, count: count)
            
            XorshiftGenerator.default.uniform.fill(start: &a, count: count, with: 1..<2)
            let mean = a.reduce(0, +) / T(a.count)
            
            XCTAssertEqual(mean, 1.5, accuracy: 1e-3)
            XCTAssertGreaterThanOrEqual(a.min()!, 1)
            XCTAssertLessThan(a.max()!, 2)
        }
        do {
            let count = 1_000_003
            
            let a: [T] = XorshiftGenerator.default.uniform.generate(count: count, from: 1..<2)
            let mean = a.reduce(0, +) / T(a.count)
            
            XCTAssertEqual(mean, 1.5, accuracy: 1e-3)
            XCTAssertGreaterThanOrEqual(a.min()!, 1)
            XCTAssertLessThan(a.max()!, 2)
        }
        do {
            let count = 0
            var a = [T](repeating: 0, count: count)
            
            XorshiftGenerator.default.uniform.fill(start: &a, count: count, with: -1..<1)
            
            XCTAssertEqual(a, [])
        }
    }
    
    func testXorshift_uniform_double() {
        typealias T = Double
        do {
            let count = 1_000_001
            var a = [T](repeating: 0, count: count)
            
            XorshiftGenerator.default.uniform.fill(start: &a, count: count)
            let mean = a.reduce(0, +) / T(a.count)
            
            XCTAssertEqual(mean, 0.5, accuracy: 1e-3)
            XCTAssertGreaterThanOrEqual(a.min()!, 0)
            XCTAssertLessThan(a.max()!, 1)
        }
        do {
            let count = 1_000_001
            var a = [T](repeating: 0, count: count)
            
            XorshiftGenerator.default.uniform.fill(start: &a, count: count, with: 1..<2)
            let mean = a.reduce(0, +) / T(a.count)
            
            XCTAssertEqual(mean, 1.5, accuracy: 1e-3)
            XCTAssertGreaterThanOrEqual(a.min()!, 1)
            XCTAssertLessThan(a.max()!, 2)
        }
        do {
            let count = 1_000_001
            
            let a: [T] = XorshiftGenerator.default.uniform.generate(count: count, from: 1..<2)
            let mean = a.reduce(0, +) / T(a.count)
            
            XCTAssertEqual(mean, 1.5, accuracy: 1e-3)
            XCTAssertGreaterThanOrEqual(a.min()!, 1)
            XCTAssertLessThan(a.max()!, 2)
        }
        do {
            let count = 0
            var a = [T](repeating: 0, count: count)
            
            XorshiftGenerator.default.uniform.fill(start: &a, count: count, with: -1..<1)
            
            XCTAssertEqual(a, [])
        }
    }
    
    func testXorshift_normal_float_single() {
        typealias T = Float
        do {
            let count = 1_000_001
            let a: [T] = (0..<count).map { _ in XorshiftGenerator.default.normal.next() }
            
            let mean = a.reduce(0, +) / T(a.count)
            let mean2: T = a.map { $0*$0 }.reduce(0, +) / T(a.count)
            let variance = mean2 - mean*mean
            
            XCTAssertEqual(mean, 0, accuracy: 1e-2)
            XCTAssertEqual(variance, 1, accuracy: 1e-2)
        }
    }
    
    func testXorshift_normal_double_single() {
        typealias T = Double
        do {
            let count = 1_000_001
            let a: [T] = (0..<count).map { _ in XorshiftGenerator.default.normal.next() }
            
            let mean = a.reduce(0, +) / T(a.count)
            let mean2: T = a.map { $0*$0 }.reduce(0, +) / T(a.count)
            let variance = mean2 - mean*mean
            
            XCTAssertEqual(mean, 0, accuracy: 1e-2)
            XCTAssertEqual(variance, 1, accuracy: 1e-2)
        }
    }
    
    func testXorshift_normal_float() {
        typealias T = Float
        do {
            let count = 1_000_000
            var a = [T](repeating: 0, count: count)
            
            XorshiftGenerator.default.normal.fill(start: &a, count: count, mu: -1, sigma: 0.5)
            
            let mean = a.reduce(0, +) / T(a.count)
            let mean2: T = a.map { $0*$0 }.reduce(0, +) / T(a.count)
            let variance = mean2 - mean*mean
            
            XCTAssertEqual(mean, -1, accuracy: 1e-2)
            XCTAssertEqual(variance, 0.5*0.5, accuracy: 1e-2)
        }
        do {
            let count = 1_000_001
            
            let a: [T] = XorshiftGenerator.default.normal.generate(count: count, mu: -1, sigma: 0.5)
            
            let mean = a.reduce(0, +) / T(a.count)
            let mean2: T = a.map { $0*$0 }.reduce(0, +) / T(a.count)
            let variance = mean2 - mean*mean
            
            XCTAssertEqual(mean, -1, accuracy: 1e-2)
            XCTAssertEqual(variance, 0.5*0.5, accuracy: 1e-2)
        }
        do {
            let count = 1_001
            var a = [T](repeating: -1, count: count)
            
            XorshiftGenerator.default.normal.fill(start: &a, count: count, mu: 1, sigma: 0)
            
            XCTAssertEqual(a, [T](repeating: 1, count: count))
        }
        do {
            let count = 0
            var a = [T](repeating: 0, count: count)
            
            XorshiftGenerator.default.normal.fill(start: &a, count: count, mu: 0, sigma: 1)
            
            XCTAssertEqual(a, [])
        }
    }
    
    func testXorshift_normal_dobule() {
        typealias T = Double
        do {
            let count = 1_000_000
            var a = [T](repeating: 0, count: count)
            
            XorshiftGenerator.default.normal.fill(start: &a, count: count, mu: -1, sigma: 0.5)
            
            let mean = a.reduce(0, +) / T(a.count)
            let mean2: T = a.map { $0*$0 }.reduce(0, +) / T(a.count)
            let variance = mean2 - mean*mean
            
            XCTAssertEqual(mean, -1, accuracy: 1e-2)
            XCTAssertEqual(variance, 0.5*0.5, accuracy: 1e-2)
        }
        do {
            let count = 1_000_001
            
            let a: [T] = XorshiftGenerator.default.normal.generate(count: count, mu: -1, sigma: 0.5)
            
            let mean = a.reduce(0, +) / T(a.count)
            let mean2: T = a.map { $0*$0 }.reduce(0, +) / T(a.count)
            let variance = mean2 - mean*mean
            
            XCTAssertEqual(mean, -1, accuracy: 1e-2)
            XCTAssertEqual(variance, 0.5*0.5, accuracy: 1e-2)
        }
        do {
            let count = 1_001
            var a = [T](repeating: -1, count: count)
            
            XorshiftGenerator.default.normal.fill(start: &a, count: count, mu: 1, sigma: 0)
            
            XCTAssertEqual(a, [T](repeating: 1, count: count))
        }
        do {
            let count = 0
            var a = [T](repeating: 0, count: count)
            
            XorshiftGenerator.default.normal.fill(start: &a, count: count, mu: 0, sigma: 1)
            
            XCTAssertEqual(a, [])
        }
    }
    
    func testXorshift_normal_no_accelerate_float() {
        typealias T = Float
        do {
            let count = 1_000_000
            var a = [T](repeating: 0, count: count)
            
            XorshiftGenerator.default.normal.fill_no_accelerate(start: &a, count: count, mu: -1, sigma: 0.5)
            
            let mean = a.reduce(0, +) / T(a.count)
            let mean2: T = a.map { $0*$0 }.reduce(0, +) / T(a.count)
            let variance = mean2 - mean*mean
            
            XCTAssertEqual(mean, -1, accuracy: 1e-2)
            XCTAssertEqual(variance, 0.5*0.5, accuracy: 1e-2)
        }
        do {
            let count = 1_001
            var a = [T](repeating: -1, count: count)
            
            XorshiftGenerator.default.normal.fill_no_accelerate(start: &a, count: count, mu: 1, sigma: 0)
            
            XCTAssertEqual(a, [T](repeating: 1, count: count))
        }
        do {
            let count = 0
            var a = [T](repeating: 0, count: count)
            
            XorshiftGenerator.default.normal.fill_no_accelerate(start: &a, count: count, mu: 0, sigma: 1)
            
            XCTAssertEqual(a, [])
        }
    }
    
    func testXorshift_normal_no_accelerate_dobule() {
        typealias T = Double
        do {
            let count = 1_000_000
            var a = [T](repeating: 0, count: count)
            
            XorshiftGenerator.default.normal.fill_no_accelerate(start: &a, count: count, mu: -1, sigma: 0.5)
            
            let mean = a.reduce(0, +) / T(a.count)
            let mean2: T = a.map { $0*$0 }.reduce(0, +) / T(a.count)
            let variance = mean2 - mean*mean
            
            XCTAssertEqual(mean, -1, accuracy: 1e-2)
            XCTAssertEqual(variance, 0.5*0.5, accuracy: 1e-2)
        }
        do {
            let count = 1_001
            var a = [T](repeating: -1, count: count)
            
            XorshiftGenerator.default.normal.fill_no_accelerate(start: &a, count: count, mu: 1, sigma: 0)
            
            XCTAssertEqual(a, [T](repeating: 1, count: count))
        }
        do {
            let count = 0
            var a = [T](repeating: 0, count: count)
            
            XorshiftGenerator.default.normal.fill_no_accelerate(start: &a, count: count, mu: 0, sigma: 1)
            
            XCTAssertEqual(a, [])
        }
    }
}
