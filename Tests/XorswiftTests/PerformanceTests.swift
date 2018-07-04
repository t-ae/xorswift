import XCTest
#if canImport(Accelerate)
import Accelerate
#endif
import Xorswift

class PerformanceTests: XCTestCase {
}

extension PerformanceTests {
    func testPerformance_arc4random_single() {
        measure {
            for _ in 0..<10_000_000 {
                _ = arc4random()
            }
        }
    }
    
    func testPerformance_xorshift_single() {
        measure {
            for _ in 0..<10_000_000 {
                _ = XorshiftGenerator.default.next() as UInt32
            }
        }
    }
}

extension PerformanceTests {
    func testPerformance_arc4random() {
        let count = 1_000_000
        var a = [UInt32](repeating: 0, count: count)
        measure {
            for _ in 0..<100 {
                arc4random_buf(&a, MemoryLayout<UInt32>.size * a.count)
            }
        }
    }
    
    func testPerformance_xorshift() {
        let count = 1_000_000
        var a = [UInt32](repeating: 0, count: count)
        measure {
            for _ in 0..<100 {
                XorshiftGenerator.default.fill(start: &a, count: a.count)
            }
        }
    }
}

extension PerformanceTests {
    #if canImport(Accelerate)
    func testPerformance_arc4random_uniform() {
        let count = 1_000_000
        var a = [Float](repeating: 0, count: count)
        measure {
            for _ in 0..<100 {
                var buf = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: count)
                defer { buf.deallocate() }
                arc4random_buf(buf.baseAddress, MemoryLayout<UInt32>.size * count)
                vDSP_vfltu32(buf.baseAddress!, 1, &a, 1, vDSP_Length(count))
                var divisor = Float(UInt64(UInt32.max)+1)
                vDSP_vsdiv(a, 1, &divisor, &a, 1, vDSP_Length(count))
            }
        }
    }
    #endif
    
    func testPerformance_xorshift_uniform_float() {
        let count = 1_000_000
        var a = [Float](repeating: 0, count: count)
        measure {
            for _ in 0..<100 {
                XorshiftGenerator.default.uniform.fill(start: &a, count: a.count, with: 0..<1)
            }
        }
    }
    
    func testPerformance_xorshift_uniform_double() {
        let count = 1_000_000
        var a = [Double](repeating: 0, count: count)
        measure {
            for _ in 0..<100 {
                XorshiftGenerator.default.uniform.fill(start: &a, count: a.count, with: 0..<1)
            }
        }
    }
}

extension PerformanceTests {
    #if canImport(Accelerate)
    func testPerformance_xorshift_normal_accelerate_float() {
        let count = 300_000
        var a = [Float](repeating: 0, count: count)
        measure {
            for _ in 0..<100 {
                XorshiftGenerator.default.normal.fill(start: &a, count: a.count, mu: 0, sigma: 1)
            }
        }
    }
    #endif
    
    func testPerformance_xorshift_normal_no_accelerate_float() {
        let count = 300_000
        var a = [Float](repeating: 0, count: count)
        measure {
            for _ in 0..<100 {
                XorshiftGenerator.default.normal.fill_no_accelerate(start: &a, count: a.count, mu: 0, sigma: 1)
            }
        }
    }
}

extension PerformanceTests {
    #if canImport(Accelerate)
    func testPerformance_xorshift_normal_accelerate_double() {
        let count = 300_000
        var a = [Double](repeating: 0, count: count)
        measure {
            for _ in 0..<100 {
                XorshiftGenerator.default.normal.fill(start: &a, count: a.count, mu: 0, sigma: 1)
            }
        }
    }
    #endif
    
    func testPerformance_xorshift_normal_no_accelerate_double() {
        let count = 300_000
        var a = [Double](repeating: 0, count: count)
        measure {
            for _ in 0..<100 {
                XorshiftGenerator.default.normal.fill_no_accelerate(start: &a, count: a.count, mu: 0, sigma: 1)
            }
        }
    }
}
