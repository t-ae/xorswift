import Foundation

#if canImport(Accelerate)
import Accelerate
#endif

protocol FloatDouble: FloatingPoint {
    static func sin(_ arg: Self) -> Self
    static func cos(_ arg: Self) -> Self
    static func log(_ arg: Self) -> Self
    static func nextafter(_ lhs: Self, _ rhs: Self) -> Self
    
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
    
    static func vfltu32(_ input: UnsafePointer<UInt32>,
                        _ output: UnsafeMutablePointer<Self>,
                        _ count: vDSP_Length)
    
    static func vsmsa(_ input: UnsafePointer<Self>,
                      _ multiplier: UnsafePointer<Self>,
                      _ adder: UnsafePointer<Self>,
                      _ output: UnsafeMutablePointer<Self>,
                      _ count: vDSP_Length)
    
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
    static func nextafter(_ lhs: Float, _ rhs: Float) -> Float {
        return Foundation.nextafter(lhs, rhs)
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
    
    static func vfltu32(_ input: UnsafePointer<UInt32>,
                        _ output: UnsafeMutablePointer<Float>,
                        _ count: vDSP_Length) {
        vDSP_vfltu32(input, 1, output, 1, count)
    }
    
    static func vsmsa(_ input: UnsafePointer<Float>,
                      _ multiplier: UnsafePointer<Float>,
                      _ adder: UnsafePointer<Float>,
                      _ output: UnsafeMutablePointer<Float>,
                      _ count: vDSP_Length) {
        vDSP_vsmsa(input, 1, multiplier, adder, output, 1, count)
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
    static func nextafter(_ lhs: Double, _ rhs: Double) -> Double {
        return Foundation.nextafter(lhs, rhs)
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
    
    static func vfltu32(_ input: UnsafePointer<UInt32>,
                        _ output: UnsafeMutablePointer<Double>,
                        _ count: vDSP_Length) {
        vDSP_vfltu32D(input, 1, output, 1, count)
    }
    
    static func vsmsa(_ input: UnsafePointer<Double>,
                      _ multiplier: UnsafePointer<Double>,
                      _ adder: UnsafePointer<Double>,
                      _ output: UnsafeMutablePointer<Double>,
                      _ count: vDSP_Length) {
        vDSP_vsmsaD(input, 1, multiplier, adder, output, 1, count)
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
}



