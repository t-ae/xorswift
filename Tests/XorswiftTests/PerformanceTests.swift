
import XCTest
#if os(macOS)
    import Accelerate
#endif
import Xorswift

#if !SWIFT_PACKAGE
class PerformanceTests: XCTestCase {
    
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
                _ = xorshift()
            }
        }
    }
    
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
                xorshift(start: &a, count: a.count)
            }
        }
    }
    
    
    #if os(macOS)
    func testPerformance_arc4random_uniform() {
        let count = 1_000_000
        var a = [Float](repeating: 0, count: count)
        measure {
            for _ in 0..<100 {
                var buf = UnsafeMutablePointer<UInt32>.allocate(capacity: count)
                defer { buf.deallocate(capacity: count) }
                arc4random_buf(buf, MemoryLayout<UInt32>.size * count)
                vDSP_vfltu32(buf, 1, &a, 1, vDSP_Length(count))
                var divisor = Float(UInt64(UInt32.max)+1)
                vDSP_vsdiv(a, 1, &divisor, &a, 1, vDSP_Length(count))
            }
        }
    }
    #endif
    
    func testPerformance_xorshift_uniform() {
        let count = 1_000_000
        var a = [Float](repeating: 0, count: count)
        measure {
            for _ in 0..<100 {
                xorshift_uniform(start: &a, count: a.count, low: 0, high: 1)
            }
        }
    }
    
    #if os(macOS)
    func testPerformance_xorshift_normal_accelerate() {
        let count = 300_000
        var a = [Float](repeating: 0, count: count)
        measure {
            for _ in 0..<100 {
                xorshift_normal(start: &a, count: a.count, mu: 0, sigma: 1)
            }
        }
    }
    #endif
    
    func testPerformance_xorshift_normal() {
        let count = 300_000
        var a = [Float](repeating: 0, count: count)
        measure {
            for _ in 0..<100 {
                _xorshift_normal(start: &a, count: a.count, mu: 0, sigma: 1)
            }
        }
    }
}
#endif
