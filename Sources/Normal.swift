import Foundation

// MARK: - General

func xorshift_normal_generic<T: FloatDouble>(mu: T,
                                             sigma: T) -> T {
    precondition(sigma >= 0, "Invalid argument: `sigma` must not be less than 0.")
    
    let r = T.random12(multiplier: -1, adder: 2)
    let t = T.random12(multiplier: 2*T.pi, adder: 0)
    
    return sigma*sqrt(-2*T.log(r))*T.sin(t) + mu
}

#if canImport(Accelerate)

import Accelerate

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
    
    // (0, 1]
    T.fill12(start: start, count: half, multiplier: -1, adder: 2)
    
    var sincosbuf = [T](repeating: 0, count: half*2)
    // [2pi, 4pi) (identical to [0, 2pi) in sin/cos)
    T.fill12(start: &sincosbuf, count: half, multiplier: 2*T.pi, adder: 0)
    
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

/// Sample random numbers from normal distribution N(mu, sigma^2).
/// - Precondition:
///   - `count` >= 0
///   - `sigma` >= 0
func xorshift_normal_generic<T: FloatDouble>(start: UnsafeMutablePointer<T>,
                                             count: Int,
                                             mu: T,
                                             sigma: T) {
    xorshift_normal_no_accelerate_generic(start: start, count: count, mu: mu, sigma: sigma)
}

#endif

/// Sample random numbers from normal distribution N(mu, sigma^2).
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
    
    let minus2sigma2 = -2*sigma*sigma
    let half = (count+1)/2
    
    // (0, 1]
    var rp = start
    T.fill12(start: rp, count: half, multiplier: -1, adder: 2)
    
    // [2pi, 4pi) (identical to [0, 2pi) in sin/cos)
    var tp = start + half
    T.fill12(start: tp, count: count-half, multiplier: 2*T.pi, adder: 0)
    
    if count%2 != 0 {
        let theta = T.random12(multiplier: 2*T.pi, adder: 0)
        rp.pointee = sqrt(minus2sigma2*T.log(rp.pointee))*T.sin(theta) + mu
        rp += 1
    }
    for _ in 0..<(count-half) {
        let r = sqrt(minus2sigma2*T.log(rp.pointee))
        let t = tp.pointee
        rp.pointee = r * T.sin(t) + mu
        tp.pointee = r * T.cos(t) + mu
        rp += 1
        tp += 1
    }
}


// MARK: - Float

/// Sample random number from normal distribution N(mu, sigma^2).
/// - Precondition:
///   - `sigma` >= 0
public func xorshift_normal(mu: Float = 0, sigma: Float = 1) -> Float {
    return xorshift_normal_generic(mu: mu, sigma: sigma)
}

/// Sample random numbers from normal distribution N(mu, sigma^2).
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

/// Sample random numbers from normal distribution N(mu, sigma^2).
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

/// Sample random numbers from normal distribution N(mu, sigma^2).
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

/// Sample random numbers from normal distribution N(mu, sigma^2).
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

/// Sample random numbers from normal distribution N(mu, sigma^2).
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

/// Sample random number from normal distribution N(mu, sigma^2).
/// - Precondition:
///   - `sigma` >= 0
public func xorshift_normal(mu: Double = 0, sigma: Double = 1) -> Double {
    return xorshift_normal_generic(mu: mu, sigma: sigma)
}

/// Sample random numbers from normal distribution N(mu, sigma^2).
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

/// Sample random numbers from normal distribution N(mu, sigma^2).
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

/// Sample random numbers from normal distribution N(mu, sigma^2).
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

/// Sample random numbers from normal distribution N(mu, sigma^2).
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


/// Sample random numbers from normal distribution N(mu, sigma^2).
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
