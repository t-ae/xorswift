// MARK: - General

#if canImport(Accelerate)

import Accelerate

/// Sample random numbers from normal distribution N(mu, sigma).
/// Using Accelerate framework.
/// - Precondition:
///   - `count` >= 0
///   - `sigma` >= 0
func xorshift_normal_generic<T: FloatDouble>(start: UnsafeMutablePointer<T>,
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
    
    var buf1 = [UInt32](repeating: 0, count: half)
    xorshift(start: &buf1, count: half)
    T.vfltu32(buf1, start, _half)
    
    var buf2 = [T](repeating: 0, count: half*2)
    xorshift(start: &buf1, count: half)
    T.vfltu32(buf1, &buf2, _half)
    
    var flt_min = T.leastNormalMagnitude
    let divisor = T.nextafter(T(UInt32.max), .infinity)
    
    // X in (0, 1)
    var mulX = 1 / divisor
    T.vsmsa(start, &mulX, &flt_min, start, _half)
    
    // Y in (0, 2pi)
    var mulY = 2*T.pi / divisor
    T.vsmsa(buf2, &mulY, &flt_min, &buf2, _half)
    
    // sigma*sqrt(-2*log(X))
    T.vlog(start, start, &__half)
    var minus2sigma2 = -2 * sigma * sigma
    T.vsmul(start, &minus2sigma2, start, _half)
    T.vsqrt(start, start, &__half)
    // copy to last half
    memcpy(start+half, start, (count - half) * MemoryLayout<T>.size)
    
    // sincos(Y)
    buf2.withUnsafeMutableBufferPointer {
        let p = $0.baseAddress!
        T.vsincos(p, p+half, p, &__half)
    }
    
    var mu = mu
    T.vmsa(start, buf2, &mu, start, _count)
}

#else

/// Generate random numbers from normal distribution N(mu, sigma).
/// - Precondition:
///   - `count` >= 0
///   - `sigma` >= 0
public func xorshift_normal_generic(start: UnsafeMutablePointer<Float>,
                                    count: Int,
                                    mu: Float,
                                    sigma: Float) {
    xorshift_normal_no_accelerate_generic(start: start, count: Int32(count), mu: mu, sigma: sigma)
}

#endif

/// Sample random numbers from normal distribution N(mu, sigma).
///
/// - Note: This function is slower than `xorshift_normal` with Accelerate framework, but uses less memories.
/// - Precondition:
///   - `count` >= 0
///   - `sigma` >= 0
func xorshift_normal_no_accelerate_generic<T: FloatDouble>(start: UnsafeMutablePointer<T>,
                                                           count: Int,
                                                           mu: T,
                                                           sigma: T) {
    precondition(sigma >= 0, "Invalid argument: `sigma` must not be less than 0.")
    precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
    
    var p = start
    let divisor = T.nextafter(T(UInt32.max), .infinity)
    
    for _ in 0..<count%4 {
        var t: UInt32
        t = x ^ (x << 11)
        x = y; y = z; z = w;
        w = (w ^ (w >> 19)) ^ (t ^ (t >> 8))
        let x1 = T(w) / divisor + T.leastNormalMagnitude
        
        t = x ^ (x << 11)
        x = y; y = z; z = w;
        w = (w ^ (w >> 19)) ^ (t ^ (t >> 8))
        let x2 = T(w) / divisor + T.leastNormalMagnitude
        
        p.pointee = sigma*sqrt(-2*T.log(x1))*T.cos(2*T.pi*x2) + mu
        p += 1
    }
    
    for _ in 0..<count/4 {
        var x1, x2: T
        let t1 = x ^ (x << 11)
        let t2 = y ^ (y << 11)
        let t3 = z ^ (z << 11)
        let t4 = w ^ (w << 11)
        x = (w ^ (w >> 19)) ^ (t1 ^ (t1 >> 8))
        y = (x ^ (x >> 19)) ^ (t2 ^ (t2 >> 8))
        z = (y ^ (y >> 19)) ^ (t3 ^ (t3 >> 8))
        w = (z ^ (z >> 19)) ^ (t4 ^ (t4 >> 8))
        
        
        x1 = T(x) / divisor + T.leastNormalMagnitude
        x2 = T(y) / divisor + T.leastNormalMagnitude
        p.pointee = sigma*sqrt(-2*T.log(x1))*T.sin(2*T.pi*x2) + mu
        p += 1
        p.pointee = sigma*sqrt(-2*T.log(x1))*T.cos(2*T.pi*x2) + mu
        p += 1
        
        x1 = T(z) / divisor + T.leastNormalMagnitude
        x2 = T(w) / divisor + T.leastNormalMagnitude
        p.pointee = sigma*sqrt(-2*T.log(x1))*T.sin(2*T.pi*x2) + mu
        p += 1
        p.pointee = sigma*sqrt(-2*T.log(x1))*T.cos(2*T.pi*x2) + mu
        p += 1
    }
}


// MARK: - Float

/// Sample random number from normal distribution N(mu, sigma).
/// - Precondition:
///   - `sigma` >= 0
public func xorshift_normal(mu: Float = 0, sigma: Float = 1) -> Float {
    var ret: Float = 0
    xorshift_normal_no_accelerate(start: &ret, count: 1, mu: mu, sigma: sigma)
    return ret
}

/// Sample random numbers from normal distribution N(mu, sigma).
///
/// Use Accelerate framework if available.
/// - Precondition:
///   - `count` >= 0
///   - `sigma` >= 0
public func xorshift_normal(count: Int,
                            mu: Float = 0,
                            sigma: Float = 1) -> [Float] {
    var ret = [Float](repeating: 0,  count: count)
    ret.withUnsafeMutableBufferPointer {
        xorshift_normal($0, mu: mu, sigma: sigma)
    }
    return ret
}

/// Sample random numbers from normal distribution N(mu, sigma).
///
/// Use Accelerate framework if available.
/// - Precondition:
///   - `sigma` >= 0
public func xorshift_normal(_ array: inout [Float],
                            mu: Float = 0,
                            sigma: Float = 1) {
    array.withUnsafeMutableBufferPointer {
        xorshift_normal($0, mu: mu, sigma: sigma)
    }
}

/// Sample random numbers from normal distribution N(mu, sigma).
///
/// Use Accelerate framework if available.
/// - Precondition:
///   - `sigma` >= 0
public func xorshift_normal(_ buffer: UnsafeMutableBufferPointer<Float>,
                            mu: Float = 0,
                            sigma: Float = 1) {
    buffer.baseAddress.map {
        xorshift_normal(start: $0, count: buffer.count, mu: mu, sigma: sigma)
    }
}

/// Generate random numbers from normal distribution N(mu, sigma).
///
/// Use Accelerate framework if available.
/// - Precondition:
///   - `count` >= 0
///   - `sigma` >= 0
public func xorshift_normal(start: UnsafeMutablePointer<Float>,
                            count: Int,
                            mu: Float = 0,
                            sigma: Float = 1) {
    xorshift_normal_generic(start: start, count: count, mu: mu, sigma: sigma)
}

/// Sample random numbers from normal distribution N(mu, sigma).
///
/// - Note: This function is slower than `xorshift_normal` with Accelerate framework, but uses less memories.
/// - Precondition:
///   - `count` >= 0
///   - `sigma` >= 0
public func xorshift_normal_no_accelerate(start: UnsafeMutablePointer<Float>,
                                          count: Int,
                                          mu: Float = 0,
                                          sigma: Float = 1) {
    xorshift_normal_no_accelerate_generic(start: start, count: count, mu: mu, sigma: sigma)
}


// MARK: - Double

/// Sample random number from normal distribution N(mu, sigma).
/// - Precondition:
///   - `sigma` >= 0
public func xorshift_normal(mu: Double = 0, sigma: Double = 1) -> Double {
    var ret: Double = 0
    xorshift_normal_no_accelerate(start: &ret, count: 1, mu: mu, sigma: sigma)
    return ret
}

/// Sample random numbers from normal distribution N(mu, sigma).
///
/// Use Accelerate framework if available.
/// - Precondition:
///   - `count` >= 0
///   - `sigma` >= 0
public func xorshift_normal(count: Int,
                            mu: Double = 0,
                            sigma: Double = 1) -> [Double] {
    var ret = [Double](repeating: 0,  count: count)
    ret.withUnsafeMutableBufferPointer {
        xorshift_normal($0, mu: mu, sigma: sigma)
    }
    return ret
}

/// Sample random numbers from normal distribution N(mu, sigma).
///
/// Use Accelerate framework if available.
/// - Precondition:
///   - `sigma` >= 0
public func xorshift_normal(_ array: inout [Double],
                            mu: Double = 0,
                            sigma: Double = 1) {
    array.withUnsafeMutableBufferPointer {
        xorshift_normal($0, mu: mu, sigma: sigma)
    }
}

/// Sample random numbers from normal distribution N(mu, sigma).
///
/// Use Accelerate framework if available.
/// - Precondition:
///   - `sigma` >= 0
public func xorshift_normal(_ buffer: UnsafeMutableBufferPointer<Double>,
                            mu: Double = 0,
                            sigma: Double = 1) {
    buffer.baseAddress.map {
        xorshift_normal(start: $0, count: buffer.count, mu: mu, sigma: sigma)
    }
}

/// Generate random numbers from normal distribution N(mu, sigma).
///
/// Use Accelerate framework if available.
/// - Precondition:
///   - `count` >= 0
///   - `sigma` >= 0
public func xorshift_normal(start: UnsafeMutablePointer<Double>,
                            count: Int,
                            mu: Double = 0,
                            sigma: Double = 1) {
    xorshift_normal_generic(start: start, count: count, mu: mu, sigma: sigma)
}


/// Sample random numbers from normal distribution N(mu, sigma).
///
/// - Note: This function is slower than `xorshift_normal` with Accelerate framework, but uses less memories.
/// - Precondition:
///   - `count` >= 0
///   - `sigma` >= 0
public func xorshift_normal_no_accelerate(start: UnsafeMutablePointer<Double>,
                                          count: Int,
                                          mu: Double = 0,
                                          sigma: Double = 1) {
    xorshift_normal_no_accelerate_generic(start: start, count: count, mu: mu, sigma: sigma)
}
