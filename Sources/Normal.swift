// MARK: - Float

/// Sample random number from normal distribution N(mu, sigma).
/// - Precondition:
///   - `sigma` >= 0
public func xorshift_normal(mu: Float = 0, sigma: Float = 1) -> Float {
    precondition(sigma >= 0, "Invalid argument: `sigma` must not be less than 0.")
    
    var ret: Float = 0
    _xorshift_normal(start: &ret, count: 1, mu: mu, sigma: sigma)
    return ret
}

/// Sample random numbers from normal distribution N(mu, sigma).
/// Using Accelerate framework.
/// - Precondition:
///   - `count` >= 0
///   - `sigma` >= 0
public func xorshift_normal(count: Int,
                            mu: Float = 0,
                            sigma: Float = 1) -> [Float] {
    precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
    var ret = [Float](repeating: 0,  count: count)
    ret.withUnsafeMutableBufferPointer {
        xorshift_normal($0, mu: mu, sigma: sigma)
    }
    return ret
}

/// Sample random numbers from normal distribution N(mu, sigma).
/// Using Accelerate framework.
/// - Precondition:
///   - `sigma` >= 0
public func xorshift_normal(_ buffer: UnsafeMutableBufferPointer<Float>,
                            mu: Float = 0,
                            sigma: Float = 1) {
    buffer.baseAddress.map {
        xorshift_normal(start: $0, count: buffer.count, mu: mu, sigma: sigma)
    }
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
        
        var buf1 = [UInt32](repeating: 0, count: count)
        xorshift(start: &buf1, count: count)
        vDSP_vfltu32(buf1, 1, start, 1, __count)
        
        var buf2 = [Float](repeating: 0, count: count)
        xorshift(start: &buf1, count: count)
        vDSP_vfltu32(buf1, 1, &buf2, 1, __count)
        
        
        var flt_min = Float.leastNormalMagnitude
        let divisor: Float = nextafter(Float(UInt32.max), Float.infinity)
        
        // X in (0, 1)
        var mulX = 1 / divisor
        vDSP_vsmsa(start, 1, &mulX, &flt_min, start, 1, __count)
        
        // Y in (0, 2)
        var mulY = 2 / divisor
        vDSP_vsmsa(buf2, 1, &mulY, &flt_min, &buf2, 1, __count)
        
        // sigma*sqrt(-2*log(X))
        vvlogf(start, start, &_count)
        var minus2sigma2 = -2 * sigma * sigma
        vDSP_vsmul(start, 1, &minus2sigma2, start, 1, __count)
        vvsqrtf(start, start, &_count)
        
        // cospi(Y)
        vvcospif(&buf2, buf2, &_count)
        
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


// MARK: - Double

/// Sample random number from normal distribution N(mu, sigma).
/// - Precondition:
///   - `sigma` >= 0
public func xorshift_normal(mu: Double = 0, sigma: Double = 1) -> Double {
    precondition(sigma >= 0, "Invalid argument: `sigma` must not be less than 0.")
    
    var ret: Double = 0
    _xorshift_normal(start: &ret, count: 1, mu: mu, sigma: sigma)
    return ret
}

/// Sample random numbers from normal distribution N(mu, sigma).
/// Using Accelerate framework.
/// - Precondition:
///   - `count` >= 0
///   - `sigma` >= 0
public func xorshift_normal(count: Int,
                            mu: Double = 0,
                            sigma: Double = 1) -> [Double] {
    precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
    var ret = [Double](repeating: 0,  count: count)
    ret.withUnsafeMutableBufferPointer {
        xorshift_normal($0, mu: mu, sigma: sigma)
    }
    return ret
}

/// Sample random numbers from normal distribution N(mu, sigma).
/// Using Accelerate framework.
/// - Precondition:
///   - `sigma` >= 0
public func xorshift_normal(_ buffer: UnsafeMutableBufferPointer<Double>,
                            mu: Double = 0,
                            sigma: Double = 1) {
    buffer.baseAddress.map {
        xorshift_normal(start: $0, count: buffer.count, mu: mu, sigma: sigma)
    }
}

#if os(macOS) || os(iOS)
    import Accelerate
    
    /// Sample random numbers from normal distribution N(mu, sigma).
    /// Using Accelerate framework.
    /// - Precondition:
    ///   - `count` >= 0
    ///   - `sigma` >= 0
    public func xorshift_normal(start: UnsafeMutablePointer<Double>,
                                count: Int,
                                mu: Double = 0,
                                sigma: Double = 1) {
        
        precondition(sigma >= 0, "Invalid argument: `sigma` must not be less than 0.")
        precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
        
        var _count = Int32(count)
        let __count = vDSP_Length(count)
        
        var buf1 = [UInt32](repeating: 0, count: count)
        xorshift(start: &buf1, count: count)
        vDSP_vfltu32D(buf1, 1, start, 1, __count)
        
        var buf2 = [Double](repeating: 0, count: count)
        xorshift(start: &buf1, count: count)
        vDSP_vfltu32D(buf1, 1, &buf2, 1, __count)
        
        
        var flt_min = Double.leastNormalMagnitude
        let divisor: Double = nextafter(Double(UInt32.max), Double.infinity)
        
        // X in (0, 1)
        var mulX = 1 / divisor
        vDSP_vsmsaD(start, 1, &mulX, &flt_min, start, 1, __count)
        
        // Y in (0, 2)
        var mulY = 2 / divisor
        vDSP_vsmsaD(buf2, 1, &mulY, &flt_min, &buf2, 1, __count)
        
        // sigma*sqrt(-2*log(X))
        vvlog(start, start, &_count)
        var minus2sigma2 = -2 * sigma * sigma
        vDSP_vsmulD(start, 1, &minus2sigma2, start, 1, __count)
        vvsqrt(start, start, &_count)
        
        // cospi(Y)
        vvcospi(&buf2, buf2, &_count)
        
        vDSP_vmulD(start, 1, buf2, 1, start, 1, __count)
        
        if(mu != 0) {
            var mu = mu
            vDSP_vsaddD(start, 1, &mu, start, 1, __count)
        }
    }
#else
    /// Generate random numbers from normal distribution N(mu, sigma).
    /// - Precondition:
    ///   - `count` >= 0
    ///   - `sigma` >= 0
    public func xorshift_normal(start: UnsafeMutablePointer<Double>,
                                count: Int,
                                mu: Double = 0,
                                sigma: Double = 1) {
        _xorshift_normal(start: start, count: Int32(count), mu: mu, sigma: sigma)
    }
#endif

/// Sample random numbers from normal distribution N(mu, sigma).
///
/// - Note: This function is slower than `xorshift_normal` with Accelerate framework, but uses less memories.
/// - Precondition:
///   - `count` >= 0
///   - `sigma` >= 0
public func _xorshift_normal(start: UnsafeMutablePointer<Double>,
                             count: Int,
                             mu: Double = 0,
                             sigma: Double = 1) {
    precondition(sigma >= 0, "Invalid argument: `sigma` must not be less than 0.")
    precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
    
    var p = start
    let divisor = Double(UInt32.max) + 1
    
    if count%2 == 1 {
        var t: UInt32
        t = x ^ (x << 11)
        x = y; y = z; z = w;
        w = (w ^ (w >> 19)) ^ (t ^ (t >> 8))
        let x1 = Double(w) / divisor + Double.leastNormalMagnitude
        
        t = x ^ (x << 11)
        x = y; y = z; z = w;
        w = (w ^ (w >> 19)) ^ (t ^ (t >> 8))
        let x2 = Double(w) / divisor + Double.leastNormalMagnitude
        
        p.pointee = sigma*sqrt(-2*log(x1))*cos(2*Double.pi*x2) + mu
        p += 1
    }
    
    for _ in 0..<count/2 {
        var x1, x2: Double
        let t1 = x ^ (x << 11)
        let t2 = y ^ (y << 11)
        let t3 = z ^ (z << 11)
        let t4 = w ^ (w << 11)
        x = (w ^ (w >> 19)) ^ (t1 ^ (t1 >> 8))
        y = (x ^ (x >> 19)) ^ (t2 ^ (t2 >> 8))
        z = (y ^ (y >> 19)) ^ (t3 ^ (t3 >> 8))
        w = (z ^ (z >> 19)) ^ (t4 ^ (t4 >> 8))
        
        
        x1 = Double(x) / divisor + Double.leastNormalMagnitude
        x2 = Double(y) / divisor + Double.leastNormalMagnitude
        p.pointee = sigma*sqrt(-2*log(x1))*cos(2*Double.pi*x2) + mu
        p += 1
        
        x1 = Double(z) / divisor + Double.leastNormalMagnitude
        x2 = Double(w) / divisor + Double.leastNormalMagnitude
        p.pointee = sigma*sqrt(-2*log(x1))*cos(2*Double.pi*x2) + mu
        p += 1
    }
}
