import XCTest
#if canImport(Accelerate)
import Accelerate
#endif
import Xorswift

class PerformanceTests: XCTestCase {
}

#if !DEBUG
extension PerformanceTests {
    #if os(macOS)
    func testPerformance_arc4random_single() {
        measure {
            for _ in 0..<10_000_000 {
                _ = arc4random()
            }
        }
    }
    #endif
    
    func testPerformance_xorshift_single() {
        measure {
            var gen = XorshiftGenerator()
            for _ in 0..<10_000_000 {
                _ = gen.next() as UInt32
            }
        }
    }
    
    func testPerformance_xorshift_single64() {
        measure {
            var gen = XorshiftGenerator()
            for _ in 0..<10_000_000 {
                _ = gen.next() as UInt64
            }
        }
    }
    
    func testPerformance_xorshift_plus_single64() {
        measure {
            var gen = XorshiftPlusGenerator()
            for _ in 0..<10_000_000 {
                _ = gen.next() as UInt64
            }
        }
    }
}

extension PerformanceTests {
    #if os(macOS)
    func testPerformance_arc4random() {
        let count = 1_000_000
        var a = [UInt32](repeating: 0, count: count)
        measure {
            for _ in 0..<100 {
                arc4random_buf(&a, MemoryLayout<UInt32>.size * a.count)
            }
        }
    }
    #endif
    
    func testPerformance_xorshift() {
        let count = 1_000_000
        var a = [UInt32](repeating: 0, count: count)
        measure {
            var gen = XorshiftGenerator()
            for _ in 0..<100 {
                gen.fill(start: &a, count: a.count)
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
            var gen = XorshiftGenerator()
            for _ in 0..<100 {
                gen.fillUniform(start: &a, count: a.count, with: 0..<1)
            }
        }
    }
    
    func testPerformance_xorshift_uniform_double() {
        let count = 1_000_000
        var a = [Double](repeating: 0, count: count)
        measure {
            var gen = XorshiftGenerator()
            for _ in 0..<100 {
                gen.fillUniform(start: &a, count: a.count, with: 0..<1)
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
            var gen = XorshiftGenerator()
            for _ in 0..<100 {
                gen.fillNormal(start: &a, count: a.count, mu: 0, sigma: 1)
            }
        }
    }
    #endif
    
    func testPerformance_xorshift_normal_no_accelerate_float() {
        let count = 300_000
        var a = [Float](repeating: 0, count: count)
        measure {
            var gen = XorshiftGenerator()
            for _ in 0..<100 {
                gen.fillNormal_no_accelerate(start: &a, count: a.count, mu: 0, sigma: 1)
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
            var gen = XorshiftGenerator()
            for _ in 0..<100 {
                gen.fillNormal(start: &a, count: a.count, mu: 0, sigma: 1)
            }
        }
    }
    #endif
    
    func testPerformance_xorshift_normal_no_accelerate_double() {
        let count = 300_000
        var a = [Double](repeating: 0, count: count)
        measure {
            var gen = XorshiftGenerator()
            for _ in 0..<100 {
                gen.fillNormal_no_accelerate(start: &a, count: a.count, mu: 0, sigma: 1)
            }
        }
    }
}
#endif
