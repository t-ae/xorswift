import Foundation

// MARK: - Generic

func xorshift_uniform_generic<T: FloatDouble>(low: T,
                                              high: T) -> T {
    precondition(low < high, "Invalid argument: must be `low` < `high`")
    return T.random12(multiplier: high - low, adder: low*2 - high, x:
        &x, y: &y, z: &z, w: &w)
}

func xorshift_uniform_generic<T: FloatDouble>(start: UnsafeMutablePointer<T>,
                                              count: Int,
                                              low: T,
                                              high: T) {
    precondition(low < high, "Invalid argument: must be `low` < `high`")
    precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
    
    // Z = (high-low) * (X - 1) + low ( X \in [1, 2) )
    T.fill12(start: start, count: count, multiplier: high - low, adder: low*2 - high,
             x: &x, y: &y, z: &z, w: &w)
}

// MARK: - Float

/// Sample random Float number from unifrom distribution [low, high).
/// - Precondition:
///   - `low` < `high`
public func xorshift_uniform(low: Float = 0,
                             high: Float = 1) -> Float {
    return xorshift_uniform_generic(low: low, high: high)
}

/// Sample random Float numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `count` >= 0
///   - `low` < `high`
public func xorshift_uniform(count: Int,
                             low: Float = 0,
                             high: Float = 1) -> [Float] {
    var ret = [Float](repeating: 0,  count: count)
    ret.withUnsafeMutableBufferPointer {
        xorshift_uniform($0, low: low, high: high)
    }
    return ret
}

/// Sample random Float numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `low` < `high`
public func xorshift_uniform(_ array: inout [Float],
                             low: Float = 0,
                             high: Float = 1) {
    array.withUnsafeMutableBufferPointer {
        xorshift_uniform($0, low: low, high: high)
    }
}

/// Sample random Float numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `low` < `high`
public func xorshift_uniform(_ buffer: UnsafeMutableBufferPointer<Float>,
                             low: Float = 0,
                             high: Float = 1) {
    buffer.baseAddress.map {
        xorshift_uniform(start: $0, count: buffer.count, low: low, high: high)
    }
}

/// Sample random Float numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `count` >= 0
///   - `low` < `high`
public func xorshift_uniform(start: UnsafeMutablePointer<Float>,
                             count: Int,
                             low: Float = 0,
                             high: Float = 1) {
    xorshift_uniform_generic(start: start, count: count, low: low, high: high)
}


// MARK: - Double

/// Sample random Double number from unifrom distribution [low, high).
/// - Precondition:
///   - `low` < `high`
public func xorshift_uniform(low: Double = 0,
                             high: Double = 1) -> Double {
    return xorshift_uniform_generic(low: low, high: high)
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
        xorshift_uniform($0, low: low, high: high)
    }
    return ret
}

/// Sample random Double numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `low` < `high`
public func xorshift_uniform(_ array: inout [Double],
                             low: Double = 0,
                             high: Double = 1) {
    array.withUnsafeMutableBufferPointer {
        xorshift_uniform($0, low: low, high: high)
    }
}

/// Sample random Double numbers from unifrom distribution [low, high).
/// - Precondition:
///   - `low` < `high`
public func xorshift_uniform(_ buffer: UnsafeMutableBufferPointer<Double>,
                             low: Double = 0,
                             high: Double = 1) {
    buffer.baseAddress.map {
        xorshift_uniform(start: $0, count: buffer.count, low: low, high: high)
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

public struct Uniform {
    var base: XorshiftGenerator
    init(base: XorshiftGenerator) {
        self.base = base
    }
    
    // MARK: Generic
    mutating func next_generic<T: FloatDouble>(low: T, high: T) -> T {
        precondition(low < high, "Invalid argument: must be `low` < `high`")
        return T.random12(multiplier: high - low,
                          adder: 2*low-high,
                          x: &base.x, y: &base.y, z: &base.z, w: &base.w)
    }
    
    mutating func fill_generic<T: FloatDouble>(start: UnsafeMutablePointer<T>, count: Int, low: T, high: T) {
        precondition(low < high, "Invalid argument: must be `low` < `high`")
        precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
        T.fill12(start: start,
                 count: count,
                 multiplier: high - low,
                 adder: 2*low - high,
                 x: &base.x, y: &base.y, z: &base.z, w: &base.w)
    }
    
    // MARK: Float
    
    /// Sample random number from unifrom distribution [low, high).
    /// - Precondition:
    ///   - `low` < `high`
    public mutating func next(low: Float, high: Float) -> Float {
        return next_generic(low: low, high: high)
    }
    
    /// Sample random numbers from unifrom distribution [low, high).
    /// - Precondition:
    ///   - `count` >= 0
    ///   - `low` < `high`
    public mutating func generate(count: Int, low: Float, high: Float) -> [Float] {
        var array = [Float](repeating: 0, count: count)
        fill(&array, low: low, high: high)
        return array
    }
    
    /// Sample random numbers from unifrom distribution [low, high).
    /// - Precondition:
    ///   - `low` < `high`
    public mutating func fill(_ array: inout [Float], low: Float, high: Float) {
        array.withUnsafeMutableBufferPointer {
            fill($0, low: low, high: high)
        }
    }
    
    /// Sample random numbers from unifrom distribution [low, high).
    /// - Precondition:
    ///   - `count` >= 0
    ///   - `low` < `high`
    public mutating func fill(_ buffer: UnsafeMutableBufferPointer<Float>, low: Float, high: Float) {
        buffer.baseAddress.map {
            fill(start: $0, count: buffer.count, low: low, high: high)
        }
    }
    
    /// Sample random numbers from unifrom distribution [low, high).
    /// - Precondition:
    ///   - `count` >= 0
    ///   - `low` < `high`
    public mutating func fill(start: UnsafeMutablePointer<Float>,
                              count: Int,
                              low: Float,
                              high: Float) {
        fill_generic(start: start, count: count, low: low, high: high)
    }
    
    
    // MARK: Double
    
    /// Sample random Float number from unifrom distribution [low, high).
    /// - Precondition:
    ///   - `low` < `high`
    public mutating func next(low: Double, high: Double) -> Double {
        return next_generic(low: low, high: high)
    }
    
    /// Sample random numbers from unifrom distribution [low, high).
    /// - Precondition:
    ///   - `count` >= 0
    ///   - `low` < `high`
    public mutating func generate(count: Int, low: Double, high: Double) -> [Double] {
        var array = [Double](repeating: 0, count: count)
        fill(&array, low: low, high: high)
        return array
    }
    
    /// Sample random numbers from unifrom distribution [low, high).
    /// - Precondition:
    ///   - `low` < `high`
    public mutating func fill(_ array: inout [Double], low: Double, high: Double) {
        array.withUnsafeMutableBufferPointer {
            fill($0, low: low, high: high)
        }
    }
    
    /// Sample random numbers from unifrom distribution [low, high).
    /// - Precondition:
    ///   - `count` >= 0
    ///   - `low` < `high`
    public mutating func fill(_ buffer: UnsafeMutableBufferPointer<Double>, low: Double, high: Double) {
        buffer.baseAddress.map {
            fill(start: $0, count: buffer.count, low: low, high: high)
        }
    }
    
    /// Sample random numbers from unifrom distribution [low, high).
    /// - Precondition:
    ///   - `count` >= 0
    ///   - `low` < `high`
    public mutating func fill(start: UnsafeMutablePointer<Double>,
                              count: Int,
                              low: Double,
                              high: Double) {
        fill_generic(start: start, count: count, low: low, high: high)
    }
}


extension XorshiftGenerator {
    public var uniform: Uniform {
        get {
            return Uniform(base: self)
        }
        set {
            self = newValue.base
        }
    }
}
