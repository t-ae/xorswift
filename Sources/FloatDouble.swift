import Foundation

#if canImport(Accelerate)
import Accelerate
#endif

protocol FloatDouble: FloatingPoint {
    static func sin(_ arg: Self) -> Self
    static func cos(_ arg: Self) -> Self
    static func log(_ arg: Self) -> Self
    
    #if canImport(Accelerate)
    
    static func vsincos(_ sinOut: UnsafeMutablePointer<Self>,
                        _ cosOut: UnsafeMutablePointer<Self>,
                        _ input: UnsafePointer<Self>,
                        _ count: UnsafePointer<Int32>)
    
    static func vlog(_ output: UnsafeMutablePointer<Self>,
                     _ input: UnsafePointer<Self>,
                     _ count: UnsafePointer<Int32>)
    
    static func vsqrt(_ output: UnsafeMutablePointer<Self>,
                      _ input: UnsafePointer<Self>,
                      _ count: UnsafePointer<Int32>)
    
    static func vmsa(_ input: UnsafePointer<Self>,
                     _ multiplier: UnsafePointer<Self>,
                     _ adder: UnsafePointer<Self>,
                     _ output: UnsafeMutablePointer<Self>,
                     _ count: vDSP_Length)
    
    static func vsmul(_ input: UnsafePointer<Self>,
                      _ multiplier: UnsafePointer<Self>,
                      _ output: UnsafeMutablePointer<Self>,
                      _ count: vDSP_Length)
    
    #endif
    
    /// Sample from range
    static func fill(start: UnsafeMutablePointer<Self>,
                     count: Int,
                     range: Range<Self>,
                     x: inout UInt32,
                     y: inout UInt32,
                     z: inout UInt32,
                     w: inout UInt32)
    
    /// Sample from (0, high)
    static func fillOpen(start: UnsafeMutablePointer<Self>,
                         count: Int,
                         high: Self,
                         x: inout UInt32,
                         y: inout UInt32,
                         z: inout UInt32,
                         w: inout UInt32)
    
}

extension Float: FloatDouble {
    static func sin(_ arg: Float) -> Float {
        return Foundation.sin(arg)
    }
    static func cos(_ arg: Float) -> Float {
        return Foundation.cos(arg)
    }
    static func log(_ arg: Float) -> Float {
        return Foundation.log(arg)
    }
    
    #if canImport(Accelerate)
    
    static func vsincos(_ sinOut: UnsafeMutablePointer<Float>,
                        _ cosOut: UnsafeMutablePointer<Float>,
                        _ input: UnsafePointer<Float>,
                        _ count: UnsafePointer<Int32>) {
        vvsincosf(sinOut, cosOut, input, count)
    }
    
    static func vlog(_ output: UnsafeMutablePointer<Float>,
                     _ input: UnsafePointer<Float>,
                     _ count: UnsafePointer<Int32>) {
        vvlogf(output, input, count)
    }
    
    static func vsqrt(_ output: UnsafeMutablePointer<Float>,
                      _ input: UnsafePointer<Float>,
                      _ count: UnsafePointer<Int32>) {
        vvsqrtf(output, input, count)
    }
    
    static func vmsa(_ input: UnsafePointer<Float>,
                     _ multiplier: UnsafePointer<Float>,
                     _ adder: UnsafePointer<Float>,
                     _ output: UnsafeMutablePointer<Float>,
                     _ count: vDSP_Length) {
        vDSP_vmsa(input, 1, multiplier, 1, adder, output, 1, count)
    }
    
    static func vsmul(_ input: UnsafePointer<Float>,
                      _ multiplier: UnsafePointer<Float>,
                      _ output: UnsafeMutablePointer<Float>,
                      _ count: vDSP_Length) {
        vDSP_vsmul(input, 1, multiplier, output, 1, count)
    }
    
    #endif
    
    static func fill(start: UnsafeMutablePointer<Float>,
                     count: Int,
                     range: Range<Float>,
                     x: inout UInt32,
                     y: inout UInt32,
                     z: inout UInt32,
                     w: inout UInt32) {
        
        var p = start
        
        let multiplier = (range.upperBound - range.lowerBound) * .ulpOfOne/2
        
        for _ in 0..<count {
            repeat {
                let t = x ^ (x << 11)
                x = y; y = z; z = w;
                w = (w ^ (w >> 19)) ^ (t ^ (t >> 8))
                p.pointee = Float(w>>8) * multiplier + range.lowerBound
            } while p.pointee == range.upperBound
            p += 1
        }
    }
    
    static func fillOpen(start: UnsafeMutablePointer<Float>,
                         count: Int,
                         high: Float,
                         x: inout UInt32,
                         y: inout UInt32,
                         z: inout UInt32,
                         w: inout UInt32) {
        
        var p = start
        
        let multiplier = high * .ulpOfOne/2
        
        for _ in 0..<count {
            var uint32: UInt32 = 0
            repeat {
                let t = x ^ (x << 11)
                x = y; y = z; z = w;
                w = (w ^ (w >> 19)) ^ (t ^ (t >> 8))
                uint32 = w >> 8
            } while uint32 == 0
            p.pointee = Float(uint32) * multiplier
            p += 1
        }
    }
}

extension Double: FloatDouble {
    static func sin(_ arg: Double) -> Double {
        return Foundation.sin(arg)
    }
    static func cos(_ arg: Double) -> Double {
        return Foundation.cos(arg)
    }
    static func log(_ arg: Double) -> Double {
        return Foundation.log(arg)
    }
    
    #if canImport(Accelerate)
    
    static func vsincos(_ sinOut: UnsafeMutablePointer<Double>,
                        _ cosOut: UnsafeMutablePointer<Double>,
                        _ input: UnsafePointer<Double>,
                        _ count: UnsafePointer<Int32>) {
        vvsincos(sinOut, cosOut, input, count)
    }
    
    static func vlog(_ output: UnsafeMutablePointer<Double>,
                     _ input: UnsafePointer<Double>,
                     _ count: UnsafePointer<Int32>) {
        vvlog(output, input, count)
    }
    
    static func vsqrt(_ output: UnsafeMutablePointer<Double>,
                      _ input: UnsafePointer<Double>,
                      _ count: UnsafePointer<Int32>) {
        vvsqrt(output, input, count)
    }
    
    static func vmsa(_ input: UnsafePointer<Double>,
                     _ multiplier: UnsafePointer<Double>,
                     _ adder: UnsafePointer<Double>,
                     _ output: UnsafeMutablePointer<Double>,
                     _ count: vDSP_Length) {
        vDSP_vmsaD(input, 1, multiplier, 1, adder, output, 1, count)
    }
    
    static func vsmul(_ input: UnsafePointer<Double>,
                      _ multiplier: UnsafePointer<Double>,
                      _ output: UnsafeMutablePointer<Double>,
                      _ count: vDSP_Length) {
        vDSP_vsmulD(input, 1, multiplier, output, 1, count)
    }
    
    #endif
    
    static func fill(start: UnsafeMutablePointer<Double>,
                     count: Int,
                     range: Range<Double>,
                     x: inout UInt32,
                     y: inout UInt32,
                     z: inout UInt32,
                     w: inout UInt32) {
        var p = start
        
        let multiplier = (range.upperBound - range.lowerBound) * .ulpOfOne/2
        
        for _ in 0..<count {
            repeat {
                let t1 = x ^ (x << 11)
                let t2 = y ^ (y << 11)
                x = z; y = w;
                z = (x ^ (x >> 19)) ^ (t1 ^ (t1 >> 8))
                w = (y ^ (y >> 19)) ^ (t2 ^ (t2 >> 8))
                p.pointee = Double(UInt64(z<<11)<<21 | UInt64(w)) * multiplier + range.lowerBound
            } while p.pointee == range.upperBound
            p += 1
        }
    }
    
    static func fillOpen(start: UnsafeMutablePointer<Double>,
                         count: Int,
                         high: Double,
                         x: inout UInt32,
                         y: inout UInt32,
                         z: inout UInt32,
                         w: inout UInt32) {
        var p = start
        
        let multiplier = high * .ulpOfOne/2
        
        for _ in 0..<count {
            var uint64: UInt64 = 0
            repeat {
                let t1 = x ^ (x << 11)
                let t2 = y ^ (y << 11)
                x = z; y = w;
                z = (x ^ (x >> 19)) ^ (t1 ^ (t1 >> 8))
                w = (y ^ (y >> 19)) ^ (t2 ^ (t2 >> 8))
                uint64 = UInt64(z<<11)<<21 | UInt64(w)
            } while uint64 == 0
            p.pointee = Double(uint64) * multiplier
            p += 1
        }
    }
}
