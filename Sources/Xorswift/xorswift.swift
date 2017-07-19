
import Cxorswift

/// Generate single random UInt32 number.
public func xorshift() -> UInt32 {
    var ret: UInt32 = 0
    xorshift(&ret, 1)
    return ret
}

/// Generate random UInt32 numbers.
/// - Precondition: 
///   - `count` >= 0
public func xorshift(start: UnsafeMutablePointer<UInt32>, count: Int) {
    precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")

    xorshift(start, Int32(count))
}

/// Sample random Float number from unifrom distribution [low, high).
/// - Precondition:
///   - `low` < `high`
public func xorshift_uniform(low: Float = 0,
                             high: Float = 1) -> Float {
    precondition(low < high, "Invalid argument: must be `low` < `high`")
    
    var ret: Float = 0
    xorshift_uniform(&ret, 1, low, high)
    return ret
}

/// Sample random Float numbers from unifrom distribution [low, high).
/// - Precondition: 
///   - `count` >= 0
///   - `low` < `high`
public func xorshift_uniform(start: UnsafeMutablePointer<Float>,
                             count: Int,
                             low: Float = 0,
                             high: Float = 1) {
    precondition(low < high, "Invalid argument: must be `low` < `high`")
    precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
    
    xorshift_uniform(start, Int32(count), low, high)
}

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    import Accelerate
    
    /// Sample random numbers from normal distribution N(mu, sigma).
    /// - Precondition:
    ///   - `count` >= 0
    ///   - `sigma` >= 0
    public func xorshift_normal(start: UnsafeMutablePointer<Float>,
                                count: Int,
                                mu: Float = 0,
                                sigma: Float = 1) {
        
        precondition(sigma >= 0, "Invalid argument: `sigma` must not be less than 0.")
        precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
        
        var _count = Int32(count)
        let __count = vDSP_Length(count)
        
        let buf1 = UnsafeMutablePointer<UInt32>.allocate(capacity: count)
        defer { buf1.deallocate(capacity: count) }
        xorshift(buf1, _count)
        vDSP_vfltu32(buf1, 1, start, 1, __count)
        
        let buf2 = UnsafeMutablePointer<Float>.allocate(capacity: count)
        defer { buf2.deallocate(capacity: count) }
        xorshift(buf1, _count)
        vDSP_vfltu32(buf1, 1, buf2, 1, __count)
        
        // X, Y in (0, 1)
        var divisor: Float = nextafter(Float(UInt32.max), Float(UInt64.max))
        var flt_min = Float.leastNonzeroMagnitude
        vDSP_vsdiv(start, 1, &divisor, start, 1, __count)
        vDSP_vsadd(start, 1, &flt_min, start, 1, __count)
        vDSP_vsdiv(buf2, 1, &divisor, buf2, 1, __count)
        vDSP_vsadd(buf2, 1, &flt_min, buf2, 1, __count)
        
        // sigma*sqrt(-2*log(X))
        vvlogf(start, start, &_count)
        var minus2sigma2 = -2 * sigma * sigma
        vDSP_vsmul(start, 1, &minus2sigma2, start, 1, __count)
        vvsqrtf(start, start, &_count)
        
        // cos(2*pi*Y)
        var pi2 = 2 * Float.pi
        vDSP_vsmul(buf2, 1, &pi2, buf2, 1, __count)
        vvcosf(buf2, buf2, &_count)
        
        vDSP_vmul(start, 1, buf2, 1, start, 1, __count)
        
        if(mu != 0) {
            var mu = mu
            vDSP_vsadd(start, 1, &mu, start, 1, __count)
        }
    }
#else
    /// Generate random numbers from normal distribution N(mu, sigma).
    /// - Precondition:
    ///   - `count` >= 0
    ///   - `sigma` >= 0
    public func xorshift_normal(start: UnsafeMutablePointer<Float>,
                                count: Int,
                                mu: Float = 0,
                                sigma: Float = 1) {
        precondition(sigma >= 0, "Invalid argument: `sigma` must not be less than 0.")
        precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
        
        _xorshift_normal(start, Int32(count), mu, sigma)
    }
#endif

/// Sample random number from normal distribution N(mu, sigma).
/// - Precondition:
///   - `sigma` >= 0
public func xorshift_normal(mu: Float = 0, sigma: Float = 1) -> Float {
    precondition(sigma >= 0, "Invalid argument: `sigma` must not be less than 0.")
    
    var ret: Float = 0
    _xorshift_normal(&ret, 1, mu, sigma)
    return ret
}

/// Sample random numbers from normal distribution N(mu, sigma).
///
/// - Note: It's slower than `xorshift_normal` in apple devices, but use less memories.
/// - Precondition:
///   - `count` >= 0
///   - `sigma` >= 0
public func _xorshift_normal(start: UnsafeMutablePointer<Float>,
                             count: Int,
                             mu: Float = 0,
                             sigma: Float = 1) {
    precondition(sigma >= 0, "Invalid argument: `sigma` must not be less than 0.")
    precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
    
    _xorshift_normal(start, Int32(count), mu, sigma)
}
