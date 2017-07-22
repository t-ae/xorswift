
// state
var x = arc4random()
var y = arc4random()
var z = arc4random()
var w = arc4random()

// MARK: - xorshift

/// Generate single random UInt32 number.
public func xorshift() -> UInt32 {
    var ret: UInt32 = 0
    xorshift(start: &ret, count: 1)
    return ret
}

/// Generate random UInt32 numbers.
/// - Precondition: 
///   - `count` >= 0
public func xorshift(start: UnsafeMutablePointer<UInt32>, count: Int) {
    precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
    
    var p = start
    
    for _ in 0..<count%4 {
        let t = x ^ (x << 11)
        x = y; y = z; z = w;
        w = (w ^ (w >> 19)) ^ (t ^ (t >> 8))
        p.pointee = w
        p += 1
    }
    
    for _ in 0..<count/4 {
        let t1 = x ^ (x << 11)
        let t2 = y ^ (y << 11)
        let t3 = z ^ (z << 11)
        let t4 = w ^ (w << 11)
        x = (w ^ (w >> 19)) ^ (t1 ^ (t1 >> 8))
        y = (x ^ (x >> 19)) ^ (t2 ^ (t2 >> 8))
        z = (y ^ (y >> 19)) ^ (t3 ^ (t3 >> 8))
        w = (z ^ (z >> 19)) ^ (t4 ^ (t4 >> 8))
        p.pointee = x
        p += 1
        p.pointee = y
        p += 1
        p.pointee = z
        p += 1
        p.pointee = w
        p += 1
    }
}

// MARK: - xorshift_uniform

/// Sample random Float number from unifrom distribution [low, high).
/// - Precondition:
///   - `low` < `high`
public func xorshift_uniform(low: Float = 0,
                             high: Float = 1) -> Float {
    precondition(low < high, "Invalid argument: must be `low` < `high`")
    
    var ret: Float = 0
    xorshift_uniform(start: &ret, count: 1, low: low, high: high)
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
    
    var p = start
    let multiplier = (high-low) / nextafterf(Float(UInt32.max), Float.infinity)
    
    for _ in 0..<count%4 {
        let t = x ^ (x << 11)
        x = y; y = z; z = w;
        w = (w ^ (w >> 19)) ^ (t ^ (t >> 8))
        p.pointee = Float(w) * multiplier + low
        p += 1
    }
    
    for _ in 0..<count/4 {
        let t1 = x ^ (x << 11)
        let t2 = y ^ (y << 11)
        let t3 = z ^ (z << 11)
        let t4 = w ^ (w << 11)
        x = (w ^ (w >> 19)) ^ (t1 ^ (t1 >> 8))
        y = (x ^ (x >> 19)) ^ (t2 ^ (t2 >> 8))
        z = (y ^ (y >> 19)) ^ (t3 ^ (t3 >> 8))
        w = (z ^ (z >> 19)) ^ (t4 ^ (t4 >> 8))
        p.pointee = Float(x) * multiplier + low
        p += 1
        p.pointee = Float(y) * multiplier + low
        p += 1
        p.pointee = Float(z) * multiplier + low
        p += 1
        p.pointee = Float(w) * multiplier + low
        p += 1
    }
}

// MARK: - xorshift_normal

/// Sample random number from normal distribution N(mu, sigma).
/// - Precondition:
///   - `sigma` >= 0
public func xorshift_normal(mu: Float = 0, sigma: Float = 1) -> Float {
    precondition(sigma >= 0, "Invalid argument: `sigma` must not be less than 0.")
    
    var ret: Float = 0
    _xorshift_normal(start: &ret, count: 1, mu: mu, sigma: sigma)
    return ret
}

#if os(macOS) || os(iOS)
    import Accelerate
    
    /// Sample random numbers from normal distribution N(mu, sigma).
    /// Using Accelerate framework.
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
        xorshift(start: buf1, count: count)
        vDSP_vfltu32(buf1, 1, start, 1, __count)
        
        let buf2 = UnsafeMutablePointer<Float>.allocate(capacity: count)
        defer { buf2.deallocate(capacity: count) }
        xorshift(start: buf1, count: count)
        vDSP_vfltu32(buf1, 1, buf2, 1, __count)
        
        
        var flt_min = Float.leastNormalMagnitude
        let divisor: Float = nextafter(Float(UInt32.max), Float.infinity)
        
        // X in (0, 1)
        var mulX = 1 / divisor
        vDSP_vsmsa(start, 1, &mulX, &flt_min, start, 1, __count)
        
        // Y in (0, 2)
        var mulY = 2 / divisor
        vDSP_vsmsa(buf2, 1, &mulY, &flt_min, buf2, 1, __count)
        
        // sigma*sqrt(-2*log(X))
        vvlogf(start, start, &_count)
        var minus2sigma2 = -2 * sigma * sigma
        vDSP_vsmul(start, 1, &minus2sigma2, start, 1, __count)
        vvsqrtf(start, start, &_count)
        
        // cospi(Y)
        vvcospif(buf2, buf2, &_count)
        
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
        _xorshift_normal(start: start, count: Int32(count), mu: mu, sigma: sigma)
    }
#endif

/// Sample random numbers from normal distribution N(mu, sigma).
///
/// - Note: This function is slower than `xorshift_normal` with Accelerate framework, but uses less memories.
/// - Precondition:
///   - `count` >= 0
///   - `sigma` >= 0
public func _xorshift_normal(start: UnsafeMutablePointer<Float>,
                             count: Int,
                             mu: Float = 0,
                             sigma: Float = 1) {
    precondition(sigma >= 0, "Invalid argument: `sigma` must not be less than 0.")
    precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
    
    var p = start
    let divisor = nextafterf(Float(UInt32.max), Float.infinity)
    
    if count%2 == 1 {
        var t: UInt32
        t = x ^ (x << 11)
        x = y; y = z; z = w;
        w = (w ^ (w >> 19)) ^ (t ^ (t >> 8))
        let x1 = Float(w) / divisor + Float.leastNormalMagnitude
        
        t = x ^ (x << 11)
        x = y; y = z; z = w;
        w = (w ^ (w >> 19)) ^ (t ^ (t >> 8))
        let x2 = Float(w) / divisor + Float.leastNormalMagnitude
        
        p.pointee = sigma*sqrtf(-2*logf(x1))*cosf(2*Float.pi*x2) + mu
        p += 1
    }
    
    for _ in 0..<count/2 {
        var x1, x2: Float
        let t1 = x ^ (x << 11)
        let t2 = y ^ (y << 11)
        let t3 = z ^ (z << 11)
        let t4 = w ^ (w << 11)
        x = (w ^ (w >> 19)) ^ (t1 ^ (t1 >> 8))
        y = (x ^ (x >> 19)) ^ (t2 ^ (t2 >> 8))
        z = (y ^ (y >> 19)) ^ (t3 ^ (t3 >> 8))
        w = (z ^ (z >> 19)) ^ (t4 ^ (t4 >> 8))
        
        x1 = Float(x) / divisor + Float.leastNormalMagnitude
        x2 = Float(y) / divisor + Float.leastNormalMagnitude
        p.pointee = sigma*sqrtf(-2*logf(x1))*cosf(2*Float.pi*x2) + mu
        p += 1
        
        x1 = Float(z) / divisor + Float.leastNormalMagnitude
        x2 = Float(w) / divisor + Float.leastNormalMagnitude
        p.pointee = sigma*sqrtf(-2*logf(x1))*cosf(2*Float.pi*x2) + mu
        p += 1
        
        
    }
}
