
import Foundation

// MARK: - Internal

/// Sample random FloatingPoint number from unifrom distribution [low, high).
/// - Precondition:
///   - `low` < `high`
func _xorshift_uniform<T: FloatingPoint>(low: T = 0,
                                         high: T = 1) -> T {
    precondition(low < high, "Invalid argument: must be `low` < `high`")
    
    var ret: T = 0
    _xorshift_uniform(start: &ret, count: 1, low: low, high: high)
    return ret
}

/// Sample random FloatingPoint numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `count` >= 0
///   - `low` < `high`
func _xorshift_uniform<T: FloatingPoint>(count: Int,
                                         low: T = 0,
                                         high: T = 1) -> [T] {
    precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
    var ret = [T](repeating: 0,  count: count)
    ret.withUnsafeMutableBufferPointer {
        _xorshift_uniform($0, low: low, high: high)
    }
    return ret
}

/// Sample random FloatingPoint numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `low` < `high`
func _xorshift_uniform<T: FloatingPoint>(_ buffer: UnsafeMutableBufferPointer<T>,
                                         low: T = 0,
                                         high: T = 1) {
    buffer.baseAddress.map {
        _xorshift_uniform(start: $0, count: buffer.count, low: low, high: high)
    }
}

/// Sample random FloatingPoint numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `count` >= 0
///   - `low` < `high`
func _xorshift_uniform<T: FloatingPoint>(start: UnsafeMutablePointer<T>,
                                         count: Int,
                                         low: T = 0,
                                         high: T = 1) {
    precondition(low < high, "Invalid argument: must be `low` < `high`")
    precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
    
    var p = start
    let multiplier = (high-low) / (T(UInt32.max) + 1)
    
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

// MARK: - FloatingPoint

/// Sample random FloatingPoint number from unifrom distribution [low, high).
/// - Precondition:
///   - `low` < `high`
public func xorshift_uniform<T: FloatingPoint>(low: T = 0,
                                        high: T = 1) -> T {
    return _xorshift_uniform(low: low, high: high)
}

/// Sample random FloatingPoint numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `count` >= 0
///   - `low` < `high`
public func xorshift_uniform<T: FloatingPoint>(count: Int,
                                        low: T = 0,
                                        high: T = 1) -> [T] {
    return _xorshift_uniform(count: count, low: low, high: high)
}

/// Sample random FloatingPoint numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `low` < `high`
public func xorshift_uniform<T: FloatingPoint>(_ buffer: UnsafeMutableBufferPointer<T>,
                                        low: T = 0,
                                        high: T = 1) {
    _xorshift_uniform(buffer, low: low, high: high)
}

/// Sample random FloatingPoint numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `count` >= 0
///   - `low` < `high`
public func xorshift_uniform<T: FloatingPoint>(start: UnsafeMutablePointer<T>,
                                               count: Int,
                                               low: T = 0,
                                               high: T = 1) {
    _xorshift_uniform(start: start, count: count, low: low, high: high)
}

// MARK: - Float

/// Sample random Float number from unifrom distribution [low, high).
/// - Precondition:
///   - `low` < `high`
public func xorshift_uniform(low: Float = 0,
                      high: Float = 1) -> Float {
    return _xorshift_uniform(low: low, high: high)
}

/// Sample random Float numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `count` >= 0
///   - `low` < `high`
public func xorshift_uniform(count: Int,
                      low: Float = 0,
                      high: Float = 1) -> [Float] {
    return _xorshift_uniform(count: count, low: low, high: high)
}

/// Sample random Float numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `low` < `high`
public func xorshift_uniform(_ buffer: UnsafeMutableBufferPointer<Float>,
                      low: Float = 0,
                      high: Float = 1) {
    _xorshift_uniform(buffer, low: low, high: high)
}

/// Sample random Float numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `count` >= 0
///   - `low` < `high`
public func xorshift_uniform(start: UnsafeMutablePointer<Float>,
                             count: Int,
                             low: Float = 0,
                             high: Float = 1) {
    _xorshift_uniform(start: start, count: count, low: low, high: high)
}


// MARK: - Double

/// Sample random Double number from unifrom distribution [low, high).
/// - Precondition:
///   - `low` < `high`
public func xorshift_uniform(low: Double = 0,
                      high: Double = 1) -> Double {
    return _xorshift_uniform(low: low, high: high)
}

/// Sample random Double numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `count` >= 0
///   - `low` < `high`
public func xorshift_uniform(count: Int,
                      low: Double = 0,
                      high: Double = 1) -> [Double] {
    return _xorshift_uniform(count: count, low: low, high: high)
}

/// Sample random Double numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `low` < `high`
public func xorshift_uniform(_ buffer: UnsafeMutableBufferPointer<Double>,
                      low: Double = 0,
                      high: Double = 1) {
    _xorshift_uniform(buffer, low: low, high: high)
}

/// Sample random Double numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `count` >= 0
///   - `low` < `high`
public func xorshift_uniform(start: UnsafeMutablePointer<Double>,
                             count: Int,
                             low: Double = 0,
                             high: Double = 1) {
    _xorshift_uniform(start: start, count: count, low: low, high: high)
}
