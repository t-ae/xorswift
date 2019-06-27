import Foundation
#if canImport(Accelerate)
import Accelerate
#endif

extension XorshiftGenerator {
    // MARK: Generic
    #if canImport(Accelerate)
    
    @inlinable
    mutating func fillNormal_generic<T: FloatDouble>(start: UnsafeMutablePointer<T>,
                                                     count: Int,
                                                     mu: T,
                                                     sigma: T) {
        precondition(sigma >= 0, "Invalid argument: `sigma` must not be less than 0.")
        precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
        
        let _count = vDSP_Length(count)
        
        let half = (count+1)/2
        let _half = vDSP_Length(half)
        var __half = Int32(half)
        
        // First half: sigma*sqrt(-2log(X))*sin(Y) + mu
        // Last half: sigma*sqrt(-2log(X))*cos(Y) + mu
        
        // (0, 1)
        T.fillOpen(start: start, count: half, high: 1,
                   x: &x, y: &y, z: &z, w: &w)
        
        var sincosbuf = [T](repeating: 0, count: half*2)
        // (0, 2pi)
        T.fillOpen(start: &sincosbuf, count: half, high: 2*T.pi,
                   x: &x, y: &y, z: &z, w: &w)
        
        // sigma*sqrt(-2*log(X))
        T.vlog(start, start, &__half)
        var minus2sigma2 = -2 * sigma * sigma
        T.vsmul(start, &minus2sigma2, start, _half)
        T.vsqrt(start, start, &__half)
        // copy to last half
        memcpy(start+half, start, (count - half) * MemoryLayout<T>.size)
        
        // sincos(Y)
        sincosbuf.withUnsafeMutableBufferPointer {
            let p = $0.baseAddress!
            T.vsincos(p, p+half, p, &__half)
        }
        
        var mu = mu
        T.vmsa(start, sincosbuf, &mu, start, _count)
    }
    
    #else
    
    @inlinable
    mutating func fillNormal_generic<T: FloatDouble>(start: UnsafeMutablePointer<T>,
                                                     count: Int,
                                                     mu: T,
                                                     sigma: T) {
        fillNormal_generic_no_accelerate(start: start, count: count, mu: mu, sigma: sigma)
    }
    
    #endif
    
    @inlinable
    mutating func fillNormal_generic_no_accelerate<T: FloatDouble>(start: UnsafeMutablePointer<T>,
                                                                   count: Int,
                                                                   mu: T,
                                                                   sigma: T) {
        precondition(sigma >= 0, "Invalid argument: `sigma` must not be less than 0.")
        precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
        
        let minus2sigma2 = -2*sigma*sigma
        let half = (count+1)/2
        
        // (0, 1)
        var rp = start
        T.fillOpen(start: rp, count: half, high: 1,
                   x: &x, y: &y, z: &z, w: &w)
        
        // (0, 2)
        var tp = start + half
        T.fillOpen(start: tp, count: count-half, high: 2,
                   x: &x, y: &y, z: &z, w: &w)
        
        if count%2 != 0 {
            var t: T = 0
            T.fillOpen(start: &t, count: 1, high: 1,
                       x: &x, y: &y, z: &z, w: &w)
            rp.pointee = sqrt(minus2sigma2 * .log(rp.pointee)) * .sin(.pi*t) + mu
            rp += 1
        }
        for _ in 0..<(count-half) {
            let r = sqrt(minus2sigma2 * .log(rp.pointee))
            let (sin, cos) = T.sincospi(tp.pointee)
            rp.pointee = r * sin + mu
            tp.pointee = r * cos + mu
            rp += 1
            tp += 1
        }
    }
    
    // MARK: Float
    
    /// Sample random numbers from normal distribution N(mu, sigma^2).
    ///
    /// Use Accelerate framework if available.
    /// - Precondition:
    ///   - `count` >= 0
    ///   - `sigma` >= 0
    @inlinable
    public mutating func generateNormal(count: Int,
                                        mu: Float = 0,
                                        sigma: Float = 1) -> [Float] {
        var array = [Float](repeating: 0, count: count)
        fillNormal(&array, mu: mu, sigma: sigma)
        return array
    }
    
    /// Sample random numbers from normal distribution N(mu, sigma^2).
    ///
    /// Use Accelerate framework if available.
    /// - Precondition:
    ///   - `sigma` >= 0
    @inlinable
    public mutating func fillNormal(_ array: inout [Float],
                                    mu: Float = 0,
                                    sigma: Float = 1) {
        array.withUnsafeMutableBufferPointer {
            fillNormal($0, mu: mu, sigma: sigma)
        }
    }
    
    /// Sample random numbers from normal distribution N(mu, sigma^2).
    ///
    /// Use Accelerate framework if available.
    /// - Precondition:
    ///   - `sigma` >= 0
    @inlinable
    public mutating func fillNormal(_ buffer: UnsafeMutableBufferPointer<Float>,
                                    mu: Float = 0,
                                    sigma: Float = 1) {
        buffer.baseAddress.map {
            fillNormal(start: $0, count: buffer.count, mu: mu, sigma: sigma)
        }
    }
    
    /// Sample random numbers from normal distribution N(mu, sigma^2).
    ///
    /// Use Accelerate framework if available.
    /// - Precondition:
    ///   - `count` >= 0
    ///   - `sigma` >= 0
    @inlinable
    public mutating func fillNormal(start: UnsafeMutablePointer<Float>,
                                    count: Int,
                                    mu: Float = 0,
                                    sigma: Float = 1) {
        fillNormal_generic(start: start, count: count, mu: mu, sigma: sigma)
    }
    
    /// Sample random numbers from normal distribution N(mu, sigma^2).
    ///
    /// - Note: This function is slower than `fillNormal` with Accelerate framework, but uses less memories.
    /// - Precondition:
    ///   - `count` >= 0
    ///   - `sigma` >= 0
    @inlinable
    public mutating func fillNormal_no_accelerate(start: UnsafeMutablePointer<Float>,
                                                  count: Int,
                                                  mu: Float = 0,
                                                  sigma: Float = 1) {
        fillNormal_generic_no_accelerate(start: start, count: count, mu: mu, sigma: sigma)
    }
    
    // MARK: Double
    
    /// Sample random numbers from normal distribution N(mu, sigma^2).
    ///
    /// Use Accelerate framework if available.
    /// - Precondition:
    ///   - `count` >= 0
    ///   - `sigma` >= 0
    @inlinable
    public mutating func generateNormal(count: Int,
                                        mu: Double = 0,
                                        sigma: Double = 1) -> [Double] {
        var array = [Double](repeating: 0, count: count)
        fillNormal(&array, mu: mu, sigma: sigma)
        return array
    }
    
    /// Sample random numbers from normal distribution N(mu, sigma^2).
    ///
    /// Use Accelerate framework if available.
    /// - Precondition:
    ///   - `sigma` >= 0
    @inlinable
    public mutating func fillNormal(_ array: inout [Double],
                                    mu: Double = 0,
                                    sigma: Double = 1) {
        array.withUnsafeMutableBufferPointer {
            fillNormal($0, mu: mu, sigma: sigma)
        }
    }
    
    /// Sample random numbers from normal distribution N(mu, sigma^2).
    ///
    /// Use Accelerate framework if available.
    /// - Precondition:
    ///   - `sigma` >= 0
    @inlinable
    public mutating func fillNormal(_ buffer: UnsafeMutableBufferPointer<Double>,
                                    mu: Double = 0,
                                    sigma: Double = 1) {
        buffer.baseAddress.map {
            fillNormal(start: $0, count: buffer.count, mu: mu, sigma: sigma)
        }
    }
    
    /// Sample random numbers from normal distribution N(mu, sigma^2).
    ///
    /// Use Accelerate framework if available.
    /// - Precondition:
    ///   - `count` >= 0
    ///   - `sigma` >= 0
    @inlinable
    public mutating func fillNormal(start: UnsafeMutablePointer<Double>,
                                    count: Int,
                                    mu: Double = 0,
                                    sigma: Double = 1) {
        fillNormal_generic(start: start, count: count, mu: mu, sigma: sigma)
    }
    
    /// Sample random numbers from normal distribution N(mu, sigma^2).
    ///
    /// - Note: This function is slower than `fillNormal` with Accelerate framework, but uses less memories.
    /// - Precondition:
    ///   - `count` >= 0
    ///   - `sigma` >= 0
    @inlinable
    public mutating func fillNormal_no_accelerate(start: UnsafeMutablePointer<Double>,
                                                  count: Int,
                                                  mu: Double = 0,
                                                  sigma: Double = 1) {
        fillNormal_generic_no_accelerate(start: start, count: count, mu: mu, sigma: sigma)
    }
}
