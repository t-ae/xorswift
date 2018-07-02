import Foundation

extension Uniform where Base == XorshiftGenerator {
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
    public mutating func next(low: Float = 0, high: Float = 1) -> Float {
        return next_generic(low: low, high: high)
    }
    
    /// Sample random numbers from unifrom distribution [low, high).
    /// - Precondition:
    ///   - `count` >= 0
    ///   - `low` < `high`
    public mutating func generate(count: Int, low: Float = 0, high: Float = 1) -> [Float] {
        var array = [Float](repeating: 0, count: count)
        fill(&array, low: low, high: high)
        return array
    }
    
    /// Sample random numbers from unifrom distribution [low, high).
    /// - Precondition:
    ///   - `low` < `high`
    public mutating func fill(_ array: inout [Float], low: Float = 0, high: Float = 1) {
        array.withUnsafeMutableBufferPointer {
            fill($0, low: low, high: high)
        }
    }
    
    /// Sample random numbers from unifrom distribution [low, high).
    /// - Precondition:
    ///   - `count` >= 0
    ///   - `low` < `high`
    public mutating func fill(_ buffer: UnsafeMutableBufferPointer<Float>, low: Float = 0, high: Float = 1) {
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
                              low: Float = 0,
                              high: Float = 1) {
        fill_generic(start: start, count: count, low: low, high: high)
    }
    
    
    // MARK: Double
    
    /// Sample random Float number from unifrom distribution [low, high).
    /// - Precondition:
    ///   - `low` < `high`
    public mutating func next(low: Double = 0, high: Double = 1) -> Double {
        return next_generic(low: low, high: high)
    }
    
    /// Sample random numbers from unifrom distribution [low, high).
    /// - Precondition:
    ///   - `count` >= 0
    ///   - `low` < `high`
    public mutating func generate(count: Int, low: Double = 0, high: Double = 1) -> [Double] {
        var array = [Double](repeating: 0, count: count)
        fill(&array, low: low, high: high)
        return array
    }
    
    /// Sample random numbers from unifrom distribution [low, high).
    /// - Precondition:
    ///   - `low` < `high`
    public mutating func fill(_ array: inout [Double], low: Double = 0, high: Double = 1) {
        array.withUnsafeMutableBufferPointer {
            fill($0, low: low, high: high)
        }
    }
    
    /// Sample random numbers from unifrom distribution [low, high).
    /// - Precondition:
    ///   - `count` >= 0
    ///   - `low` < `high`
    public mutating func fill(_ buffer: UnsafeMutableBufferPointer<Double>, low: Double = 0, high: Double = 1) {
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
                              low: Double = 0,
                              high: Double = 1) {
        fill_generic(start: start, count: count, low: low, high: high)
    }
}
