import Foundation

#if canImport(Accelerate)
import Accelerate
#endif

@usableFromInline
protocol FloatDouble: FloatingPoint {
    static func sin(_ arg: Self) -> Self
    static func cos(_ arg: Self) -> Self
    static func log(_ arg: Self) -> Self
    static func sincospi(_ arg: Self) -> (sin: Self, cos: Self)
    
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
    @inlinable
    static func sin(_ arg: Float) -> Float {
        return Foundation.sin(arg)
    }
    @inlinable
    static func cos(_ arg: Float) -> Float {
        return Foundation.cos(arg)
    }
    @inlinable
    static func log(_ arg: Float) -> Float {
        return Foundation.log(arg)
    }
    @inlinable
    static func sincospi(_ arg: Float) -> (sin: Float, cos: Float) {
        return (sinf(arg * .pi), cosf(arg * .pi))
    }
    
    #if canImport(Accelerate)
    
    @inlinable
    static func vsincos(_ sinOut: UnsafeMutablePointer<Float>,
                        _ cosOut: UnsafeMutablePointer<Float>,
                        _ input: UnsafePointer<Float>,
                        _ count: UnsafePointer<Int32>) {
        vvsincosf(sinOut, cosOut, input, count)
    }
    
    @inlinable
    static func vlog(_ output: UnsafeMutablePointer<Float>,
                     _ input: UnsafePointer<Float>,
                     _ count: UnsafePointer<Int32>) {
        vvlogf(output, input, count)
    }
    
    @inlinable
    static func vsqrt(_ output: UnsafeMutablePointer<Float>,
                      _ input: UnsafePointer<Float>,
                      _ count: UnsafePointer<Int32>) {
        vvsqrtf(output, input, count)
    }
    
    @inlinable
    static func vmsa(_ input: UnsafePointer<Float>,
                     _ multiplier: UnsafePointer<Float>,
                     _ adder: UnsafePointer<Float>,
                     _ output: UnsafeMutablePointer<Float>,
                     _ count: vDSP_Length) {
        vDSP_vmsa(input, 1, multiplier, 1, adder, output, 1, count)
    }
    
    @inlinable
    static func vsmul(_ input: UnsafePointer<Float>,
                      _ multiplier: UnsafePointer<Float>,
                      _ output: UnsafeMutablePointer<Float>,
                      _ count: vDSP_Length) {
        vDSP_vsmul(input, 1, multiplier, output, 1, count)
    }
    
    #endif
    
    @inlinable
    static func fill(start: UnsafeMutablePointer<Float>,
                     count: Int,
                     range: Range<Float>,
                     x: inout UInt32,
                     y: inout UInt32,
                     z: inout UInt32,
                     w: inout UInt32) {
        precondition(!range.isEmpty, "Can't get random value with an empty range")
        
        let multiplier = (range.upperBound - range.lowerBound) * .ulpOfOne/2
        precondition(multiplier.isFinite, "There is no uniform distribution on an infinite range")
        
        var p = start
        let end = start + count
        for _ in 0..<count {
            let t1 = x ^ (x << 11)
            let t2 = y ^ (y << 11)
            let t3 = z ^ (z << 11)
            let t4 = w ^ (w << 11)
            
            x = w ^ (w >> 19) ^ (t1 ^ (t1 >> 8))
            y = x ^ (x >> 19) ^ (t2 ^ (t2 >> 8))
            z = y ^ (y >> 19) ^ (t3 ^ (t3 >> 8))
            w = z ^ (z >> 19) ^ (t4 ^ (t4 >> 8))
            
            p.pointee = Float(w>>8) * multiplier + range.lowerBound
            if(p.pointee < range.upperBound) {
                p += 1
                if p == end {
                    return
                }
            }
            
            p.pointee = Float(x>>8) * multiplier + range.lowerBound
            if(p.pointee < range.upperBound) {
                p += 1
                if p == end {
                    return
                }
            }
            
            p.pointee = Float(y>>8) * multiplier + range.lowerBound
            if(p.pointee < range.upperBound) {
                p += 1
                if p == end {
                    return
                }
            }
            
            p.pointee = Float(z>>8) * multiplier + range.lowerBound
            if(p.pointee < range.upperBound) {
                p += 1
                if p == end {
                    return
                }
            }
        }
    }
    
    @inlinable
    static func fillOpen(start: UnsafeMutablePointer<Float>,
                         count: Int,
                         high: Float,
                         x: inout UInt32,
                         y: inout UInt32,
                         z: inout UInt32,
                         w: inout UInt32) {
        assert(high > 0)
        
        let multiplier = high * .ulpOfOne/2
        assert(multiplier.isFinite)
        
        var p = start
        let end = start + count
        for _ in 0..<count {
            let t1 = x ^ (x << 11)
            let t2 = y ^ (y << 11)
            let t3 = z ^ (z << 11)
            let t4 = w ^ (w << 11)
            
            x = w ^ (w >> 19) ^ (t1 ^ (t1 >> 8))
            y = x ^ (x >> 19) ^ (t2 ^ (t2 >> 8))
            z = y ^ (y >> 19) ^ (t3 ^ (t3 >> 8))
            w = z ^ (z >> 19) ^ (t4 ^ (t4 >> 8))
            
            p.pointee = Float(w>>8) * multiplier
            if(p.pointee > 0) {
                p += 1
                if p == end {
                    return
                }
            }
            
            p.pointee = Float(x>>8) * multiplier
            if(p.pointee > 0) {
                p += 1
                if p == end {
                    return
                }
            }
            
            p.pointee = Float(y>>8) * multiplier
            if(p.pointee > 0) {
                p += 1
                if p == end {
                    return
                }
            }
            
            p.pointee = Float(z>>8) * multiplier
            if(p.pointee > 0) {
                p += 1
                if p == end {
                    return
                }
            }
        }
    }
}

extension Double: FloatDouble {
    @inlinable
    static func sin(_ arg: Double) -> Double {
        return Foundation.sin(arg)
    }
    @inlinable
    static func cos(_ arg: Double) -> Double {
        return Foundation.cos(arg)
    }
    @inlinable
    static func log(_ arg: Double) -> Double {
        return Foundation.log(arg)
    }
    @inlinable
    static func sincospi(_ arg: Double) -> (sin: Double, cos: Double) {
        return (sin(arg * .pi), cos(arg * .pi))
    }
    
    #if canImport(Accelerate)
    
    @inlinable
    static func vsincos(_ sinOut: UnsafeMutablePointer<Double>,
                        _ cosOut: UnsafeMutablePointer<Double>,
                        _ input: UnsafePointer<Double>,
                        _ count: UnsafePointer<Int32>) {
        vvsincos(sinOut, cosOut, input, count)
    }
    
    @inlinable
    static func vlog(_ output: UnsafeMutablePointer<Double>,
                     _ input: UnsafePointer<Double>,
                     _ count: UnsafePointer<Int32>) {
        vvlog(output, input, count)
    }
    
    @inlinable
    static func vsqrt(_ output: UnsafeMutablePointer<Double>,
                      _ input: UnsafePointer<Double>,
                      _ count: UnsafePointer<Int32>) {
        vvsqrt(output, input, count)
    }
    
    @inlinable
    static func vmsa(_ input: UnsafePointer<Double>,
                     _ multiplier: UnsafePointer<Double>,
                     _ adder: UnsafePointer<Double>,
                     _ output: UnsafeMutablePointer<Double>,
                     _ count: vDSP_Length) {
        vDSP_vmsaD(input, 1, multiplier, 1, adder, output, 1, count)
    }
    
    @inlinable
    static func vsmul(_ input: UnsafePointer<Double>,
                      _ multiplier: UnsafePointer<Double>,
                      _ output: UnsafeMutablePointer<Double>,
                      _ count: vDSP_Length) {
        vDSP_vsmulD(input, 1, multiplier, output, 1, count)
    }
    
    #endif
    
    @inlinable
    static func fill(start: UnsafeMutablePointer<Double>,
                     count: Int,
                     range: Range<Double>,
                     x: inout UInt32,
                     y: inout UInt32,
                     z: inout UInt32,
                     w: inout UInt32) {
        precondition(!range.isEmpty, "Can't get random value with an empty range")
        
        let multiplier = (range.upperBound - range.lowerBound) * .ulpOfOne/2
        precondition(multiplier.isFinite, "There is no uniform distribution on an infinite range")
        
        var p = start
        let end = start + count
        for _ in 0..<count {
            let t1 = x ^ (x << 11)
            let t2 = y ^ (y << 11)
            let t3 = z ^ (z << 11)
            let t4 = w ^ (w << 11)
            
            x = w ^ (w >> 19) ^ (t1 ^ (t1 >> 8))
            y = x ^ (x >> 19) ^ (t2 ^ (t2 >> 8))
            z = y ^ (y >> 19) ^ (t3 ^ (t3 >> 8))
            w = z ^ (z >> 19) ^ (t4 ^ (t4 >> 8))
            
            p.pointee = Double(UInt64(x<<11)<<21 | UInt64(y)) * multiplier + range.lowerBound
            if p.pointee < range.upperBound {
                p += 1
                if p == end {
                    return
                }
            }
            
            p.pointee = Double(UInt64(z<<11)<<21 | UInt64(w)) * multiplier + range.lowerBound
            if p.pointee < range.upperBound {
                p += 1
                if p == end {
                    return
                }
            }
        }
    }
    
    @inlinable
    static func fillOpen(start: UnsafeMutablePointer<Double>,
                         count: Int,
                         high: Double,
                         x: inout UInt32,
                         y: inout UInt32,
                         z: inout UInt32,
                         w: inout UInt32) {
        assert(high > 0)
        
        let multiplier = high * .ulpOfOne/2
        assert(multiplier.isFinite)
        
        var p = start
        let end = start + count
        for _ in 0..<count {
            let t1 = x ^ (x << 11)
            let t2 = y ^ (y << 11)
            let t3 = z ^ (z << 11)
            let t4 = w ^ (w << 11)
            
            x = w ^ (w >> 19) ^ (t1 ^ (t1 >> 8))
            y = x ^ (x >> 19) ^ (t2 ^ (t2 >> 8))
            z = y ^ (y >> 19) ^ (t3 ^ (t3 >> 8))
            w = z ^ (z >> 19) ^ (t4 ^ (t4 >> 8))
            
            p.pointee = Double(UInt64(x<<11)<<21 | UInt64(y)) * multiplier
            if p.pointee > 0 {
                p += 1
                if p == end {
                    return
                }
            }
            
            p.pointee = Double(UInt64(z<<11)<<21 | UInt64(w)) * multiplier
            if p.pointee > 0 {
                p += 1
                if p == end {
                    return
                }
            }
        }
    }
}
