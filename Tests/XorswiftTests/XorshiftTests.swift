import XCTest
import Foundation
import Xorswift

class XorshiftTests: XCTestCase {
    func testXorshift() {
        do {
            let count = 0
            var a = [UInt32](repeating: 0, count: count)
            var gen = XorshiftGenerator()
            gen.fill(&a)
            
            XCTAssertEqual(a, [])
        }
        do {
            let ub = UInt32(10)
            var gen = XorshiftGenerator()
            let a = (0..<10000).map { _ in gen.next(upperBound: ub) }
            
            XCTAssertEqual(Set(a).count, 10)
        }
        do {
            var resultOr: UInt64 = 0
            var resultAnd: UInt64 = 0xffff_ffff_ffff_ffff
            
            var gen = XorshiftGenerator()
            for _ in 0..<100_000 {
                resultOr |= gen.next()
                resultAnd &= gen.next()
            }
            XCTAssertEqual(resultOr, 0xffff_ffff_ffff_ffff)
            XCTAssertEqual(resultAnd, 0)
        }
    }
    
    func testXorshift_uniform_float() {
        typealias T = Float
        do {
            let count = 1_000_001
            var a = [T](repeating: 0, count: count)
            
            var gen = XorshiftGenerator()
            gen.fillUniform(start: &a, count: count)
            let mean = a.reduce(0, +) / T(a.count)
            
            XCTAssertEqual(mean, 0.5, accuracy: 1e-3)
            XCTAssertGreaterThanOrEqual(a.min()!, 0)
            XCTAssertLessThan(a.max()!, 1)
        }
        do {
            let count = 1_000_002
            var a = [T](repeating: 0, count: count)
            
            var gen = XorshiftGenerator()
            gen.fillUniform(start: &a, count: count, with: 1..<2)
            let mean = a.reduce(0, +) / T(a.count)
            
            XCTAssertEqual(mean, 1.5, accuracy: 1e-3)
            XCTAssertGreaterThanOrEqual(a.min()!, 1)
            XCTAssertLessThan(a.max()!, 2)
        }
        do {
            let count = 1_000_003
            
            var gen = XorshiftGenerator()
            let a: [T] = gen.generateUniform(count: count, from: 1..<2)
            let mean = a.reduce(0, +) / T(a.count)
            
            XCTAssertEqual(mean, 1.5, accuracy: 1e-3)
            XCTAssertGreaterThanOrEqual(a.min()!, 1)
            XCTAssertLessThan(a.max()!, 2)
        }
        do {
            let count = 0
            var a = [T](repeating: 0, count: count)
            
            var gen = XorshiftGenerator()
            gen.fillUniform(start: &a, count: count, with: -1..<1)
            
            XCTAssertEqual(a, [])
        }
    }
    
    func testXorshift_uniform_double() {
        typealias T = Double
        do {
            let count = 1_000_001
            var a = [T](repeating: 0, count: count)
            
            var gen = XorshiftGenerator()
            gen.fillUniform(start: &a, count: count)
            let mean = a.reduce(0, +) / T(a.count)
            
            XCTAssertEqual(mean, 0.5, accuracy: 1e-3)
            XCTAssertGreaterThanOrEqual(a.min()!, 0)
            XCTAssertLessThan(a.max()!, 1)
        }
        do {
            let count = 1_000_001
            var a = [T](repeating: 0, count: count)
            
            var gen = XorshiftGenerator()
            gen.fillUniform(start: &a, count: count, with: 1..<2)
            let mean = a.reduce(0, +) / T(a.count)
            
            XCTAssertEqual(mean, 1.5, accuracy: 1e-3)
            XCTAssertGreaterThanOrEqual(a.min()!, 1)
            XCTAssertLessThan(a.max()!, 2)
        }
        do {
            let count = 1_000_001
            
            var gen = XorshiftGenerator()
            let a: [T] = gen.generateUniform(count: count, from: 1..<2)
            let mean = a.reduce(0, +) / T(a.count)
            
            XCTAssertEqual(mean, 1.5, accuracy: 1e-3)
            XCTAssertGreaterThanOrEqual(a.min()!, 1)
            XCTAssertLessThan(a.max()!, 2)
        }
        do {
            let count = 0
            var a = [T](repeating: 0, count: count)
            
            var gen = XorshiftGenerator()
            gen.fillUniform(start: &a, count: count, with: -1..<1)
            
            XCTAssertEqual(a, [])
        }
    }
    
    func testXorshift_normal_float() {
        typealias T = Float
        do {
            let count = 1_000_000
            var a = [T](repeating: 0, count: count)
            
            var gen = XorshiftGenerator()
            gen.fillNormal(start: &a, count: count, mu: -1, sigma: 0.5)
            
            let mean = a.reduce(0, +) / T(a.count)
            let mean2: T = a.map { $0*$0 }.reduce(0, +) / T(a.count)
            let variance = (mean2 - mean*mean) * T(count) / T(count - 1)
            
            XCTAssertEqual(mean, -1, accuracy: 1e-2)
            XCTAssertEqual(variance, 0.5*0.5, accuracy: 1e-2)
        }
        do {
            let count = 1_000_001
            
            var gen = XorshiftGenerator()
            let a: [T] = gen.generateNormal(count: count, mu: -1, sigma: 0.5)
            
            let mean = a.reduce(0, +) / T(a.count)
            let mean2: T = a.map { $0*$0 }.reduce(0, +) / T(a.count)
            let variance = (mean2 - mean*mean) * T(count) / T(count - 1)
            
            XCTAssertEqual(mean, -1, accuracy: 1e-2)
            XCTAssertEqual(variance, 0.5*0.5, accuracy: 1e-2)
        }
        do {
            let count = 1_001
            var a = [T](repeating: -1, count: count)
            
            var gen = XorshiftGenerator()
            gen.fillNormal(start: &a, count: count, mu: 1, sigma: 0)
            
            XCTAssertEqual(a, [T](repeating: 1, count: count))
        }
        do {
            let count = 0
            var a = [T](repeating: 0, count: count)
            
            var gen = XorshiftGenerator()
            gen.fillNormal(start: &a, count: count, mu: 0, sigma: 1)
            
            XCTAssertEqual(a, [])
        }
    }
    
    func testXorshift_normal_double() {
        typealias T = Double
        do {
            let count = 1_000_000
            var a = [T](repeating: 0, count: count)
            
            var gen = XorshiftGenerator()
            gen.fillNormal(start: &a, count: count, mu: -1, sigma: 0.5)
            
            let mean = a.reduce(0, +) / T(a.count)
            let mean2: T = a.map { $0*$0 }.reduce(0, +) / T(a.count)
            let variance = (mean2 - mean*mean) * T(count) / T(count - 1)
            
            XCTAssertEqual(mean, -1, accuracy: 1e-2)
            XCTAssertEqual(variance, 0.5*0.5, accuracy: 1e-2)
        }
        do {
            let count = 1_000_001
            
            var gen = XorshiftGenerator()
            let a: [T] = gen.generateNormal(count: count, mu: -1, sigma: 0.5)
            
            let mean = a.reduce(0, +) / T(a.count)
            let mean2: T = a.map { $0*$0 }.reduce(0, +) / T(a.count)
            let variance = (mean2 - mean*mean) * T(count) / T(count - 1)
            
            XCTAssertEqual(mean, -1, accuracy: 1e-2)
            XCTAssertEqual(variance, 0.5*0.5, accuracy: 1e-2)
        }
        do {
            let count = 1_001
            var a = [T](repeating: -1, count: count)
            
            var gen = XorshiftGenerator()
            gen.fillNormal(start: &a, count: count, mu: 1, sigma: 0)
            
            XCTAssertEqual(a, [T](repeating: 1, count: count))
        }
        do {
            let count = 0
            var a = [T](repeating: 0, count: count)
            
            var gen = XorshiftGenerator()
            gen.fillNormal(start: &a, count: count, mu: 0, sigma: 1)
            
            XCTAssertEqual(a, [])
        }
    }
    
    func testXorshift_normal_no_accelerate_float() {
        typealias T = Float
        do {
            let count = 1_000_000
            var a = [T](repeating: 0, count: count)
            
            var gen = XorshiftGenerator()
            gen.fillNormal_no_accelerate(start: &a, count: count, mu: -1, sigma: 0.5)
            
            let mean = a.reduce(0, +) / T(a.count)
            let mean2: T = a.map { $0*$0 }.reduce(0, +) / T(a.count)
            let variance = (mean2 - mean*mean) * T(count) / T(count - 1)
            
            XCTAssertEqual(mean, -1, accuracy: 1e-2)
            XCTAssertEqual(variance, 0.5*0.5, accuracy: 1e-2)
        }
        do {
            let count = 1_001
            var a = [T](repeating: -1, count: count)
            
            var gen = XorshiftGenerator()
            gen.fillNormal_no_accelerate(start: &a, count: count, mu: 1, sigma: 0)
            
            XCTAssertEqual(a, [T](repeating: 1, count: count))
        }
        do {
            let count = 0
            var a = [T](repeating: 0, count: count)
            
            var gen = XorshiftGenerator()
            gen.fillNormal_no_accelerate(start: &a, count: count, mu: 0, sigma: 1)
            
            XCTAssertEqual(a, [])
        }
    }
    
    func testXorshift_normal_no_accelerate_double() {
        typealias T = Double
        do {
            let count = 1_000_000
            var a = [T](repeating: 0, count: count)
            
            var gen = XorshiftGenerator()
            gen.fillNormal_no_accelerate(start: &a, count: count, mu: -1, sigma: 0.5)
            
            let mean = a.reduce(0, +) / T(a.count)
            let mean2: T = a.map { $0*$0 }.reduce(0, +) / T(a.count)
            let variance = (mean2 - mean*mean) * T(count) / T(count - 1)
            
            XCTAssertEqual(mean, -1, accuracy: 1e-2)
            XCTAssertEqual(variance, 0.5*0.5, accuracy: 1e-2)
        }
        do {
            let count = 1_001
            var a = [T](repeating: -1, count: count)
            
            var gen = XorshiftGenerator()
            gen.fillNormal_no_accelerate(start: &a, count: count, mu: 1, sigma: 0)
            
            XCTAssertEqual(a, [T](repeating: 1, count: count))
        }
        do {
            let count = 0
            var a = [T](repeating: 0, count: count)
            
            var gen = XorshiftGenerator()
            gen.fillNormal_no_accelerate(start: &a, count: count, mu: 0, sigma: 1)
            
            XCTAssertEqual(a, [])
        }
    }
    
    static let allTests = [
        ("testXorshift", testXorshift),
        ("testXorshift_uniform_float", testXorshift_uniform_float),
        ("testXorshift_uniform_double", testXorshift_uniform_double),
        ("testXorshift_normal_float", testXorshift_normal_float),
        ("testXorshift_normal_double", testXorshift_normal_double),
        ("testXorshift_normal_no_accelerate_float", testXorshift_normal_no_accelerate_float),
        ("testXorshift_normal_no_accelerate_double", testXorshift_normal_no_accelerate_double),
    ]
}
