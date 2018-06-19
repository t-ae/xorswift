import Foundation

// MARK: - Generic

/// Sample random numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `count` >= 0
///   - `low` < `high`
func xorshift_uniform_generic<T: FloatDouble>(start: UnsafeMutablePointer<T>,
                                              count: Int,
                                              low: T = 0,
                                              high: T = 1) {
    precondition(low < high, "Invalid argument: must be `low` < `high`")
    precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
    
    var p = start
    let multiplier = (high-low) / T.nextafter(T(UInt32.max), .infinity)
    
    for _ in 0..<count%4 {
        let t = x ^ (x << 11)
        x = y; y = z; z = w;
        w = (w ^ (w >> 19)) ^ (t ^ (t >> 8))
        p.pointee = T(w) * multiplier + low
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
        p.pointee = T(x) * multiplier + low
        p += 1
        p.pointee = T(y) * multiplier + low
        p += 1
        p.pointee = T(z) * multiplier + low
        p += 1
        p.pointee = T(w) * multiplier + low
        p += 1
    }
}


// MARK: - Float

/// Sample random Float number from unifrom distribution [low, high).
/// - Precondition:
///   - `low` < `high`
public func xorshift_uniform(low: Float,
                             high: Float) -> Float {
    var ret: Float = 0
    xorshift_uniform_generic(start: &ret, count: 1, low: low, high: high)
    return ret
}

/// Sample random Float number from unifrom distribution [0, 1).
///
/// Slightly faster than `xorshift_uniform(low: 0, high: 1)`.
public func xorshift_uniform() -> Float {
    var ret: Float = 0
    xorshift_uniform(start: &ret, count: 1)
    return ret
}

/// Sample random Float numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `count` >= 0
///   - `low` < `high`
public func xorshift_uniform(count: Int,
                             low: Float,
                             high: Float) -> [Float] {
    var ret = [Float](repeating: 0,  count: count)
    ret.withUnsafeMutableBufferPointer {
        xorshift_uniform_generic(start: $0.baseAddress!, count: $0.count, low: low, high: high)
    }
    return ret
}

/// Sample random Float numbers from unifrom distribution [0, 1).
///
/// Slightly faster than `xorshift_uniform(count: count, low: 0, high: 1)`.
/// - Precondition:
///   - `count` >= 0
public func xorshift_uniform(count: Int) -> [Float] {
    var ret = [Float](repeating: 0,  count: count)
    ret.withUnsafeMutableBufferPointer {
        xorshift_uniform(start: $0.baseAddress!, count: $0.count)
    }
    return ret
}

/// Sample random Float numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `low` < `high`
public func xorshift_uniform(_ buffer: UnsafeMutableBufferPointer<Float>,
                             low: Float,
                             high: Float) {
    buffer.baseAddress.map {
        xorshift_uniform_generic(start: $0, count: buffer.count, low: low, high: high)
    }
}

/// Sample random Float numbers from unifrom distribution [0, 1).
///
/// Slightly faster than `xorshift_uniform(buffer, low: 0, high: 1)`.
public func xorshift_uniform(_ buffer: UnsafeMutableBufferPointer<Float>) {
    buffer.baseAddress.map {
        xorshift_uniform(start: $0, count: buffer.count)
    }
}

/// Sample random Float numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `count` >= 0
///   - `low` < `high`
public func xorshift_uniform(start: UnsafeMutablePointer<Float>,
                             count: Int,
                             low: Float,
                             high: Float) {
    xorshift_uniform_generic(start: start, count: count, low: low, high: high)
}

/// Sample random Float numbers from unifrom distribution [0, 1).
///
/// Slightly faster than `xorshift_uniform(start: start, count: count, low: 0, high: 1)`.
/// - Precondition:
///   - `count` >= 0
public func xorshift_uniform(start: UnsafeMutablePointer<Float>,
                             count: Int) {
    precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
    
    var p = start
    
    for _ in 0..<count%4 {
        let t = x ^ (x << 11)
        x = y; y = z; z = w;
        w = (w ^ (w >> 19)) ^ (t ^ (t >> 8))
        p.pointee = Float(bitPattern: (w & 0x007FFFFF) | 0x3f800000) - 1
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
        p.pointee = Float(bitPattern: (x & 0x007FFFFF) | 0x3f800000) - 1
        p += 1
        p.pointee = Float(bitPattern: (y & 0x007FFFFF) | 0x3f800000) - 1
        p += 1
        p.pointee = Float(bitPattern: (z & 0x007FFFFF) | 0x3f800000) - 1
        p += 1
        p.pointee = Float(bitPattern: (w & 0x007FFFFF) | 0x3f800000) - 1
        p += 1
    }
}


// MARK: - Double

/// Sample random Double number from unifrom distribution [low, high).
/// - Precondition:
///   - `low` < `high`
public func xorshift_uniform(low: Double = 0,
                             high: Double = 1) -> Double {
    var ret: Double = 0
    xorshift_uniform_generic(start: &ret, count: 1, low: low, high: high)
    return ret
}

/// Sample random Double numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `count` >= 0
///   - `low` < `high`
public func xorshift_uniform(count: Int,
                             low: Double = 0,
                             high: Double = 1) -> [Double] {
    var ret = [Double](repeating: 0,  count: count)
    ret.withUnsafeMutableBufferPointer {
        xorshift_uniform_generic(start: $0.baseAddress!, count: $0.count, low: low, high: high)
    }
    return ret
}

/// Sample random Double numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `low` < `high`
public func xorshift_uniform(_ buffer: UnsafeMutableBufferPointer<Double>,
                             low: Double = 0,
                             high: Double = 1) {
    buffer.baseAddress.map {
        xorshift_uniform_generic(start: $0, count: buffer.count, low: low, high: high)
    }
}

/// Sample random Double numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `count` >= 0
///   - `low` < `high`
public func xorshift_uniform(start: UnsafeMutablePointer<Double>,
                             count: Int,
                             low: Double = 0,
                             high: Double = 1) {
    xorshift_uniform_generic(start: start, count: count, low: low, high: high)
}
