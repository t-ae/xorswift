import Foundation

extension XorshiftGenerator {
    // MARK: Generic
    mutating func fillUniform_generic<T: FloatDouble>(start: UnsafeMutablePointer<T>, count: Int, with range: Range<T>) {
        precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
        T.fill(start: start,
               count: count,
               range: range,
               x: &x, y: &y, z: &z, w: &w)
    }
    
    // MARK: Float
    
    /// Sample random numbers from uniform distribution.
    /// - Parameters:
    ///   - count: Number of elements to sample
    ///   - range: Range of uniform distribution, default: 0..<1
    /// - Precondition:
    ///   - `count` >= 0
    public mutating func generateUniform(count: Int, from range: Range<Float> = 0..<1) -> [Float] {
        var array = [Float](repeating: 0, count: count)
        fillUniform(&array, with: range)
        return array
    }
    
    /// Sample random numbers from uniform distribution.
    /// - Parameters:
    ///   - array: Array to fill
    ///   - range: Range of uniform distribution, default: 0..<1
    public mutating func fillUniform(_ array: inout [Float], with range: Range<Float> = 0..<1) {
        array.withUnsafeMutableBufferPointer {
            fillUniform($0, with: range)
        }
    }
    
    /// Sample random numbers from uniform distribution.
    /// - Parameters:
    ///   - buffer: BufferPointer to fill
    ///   - range: Range of uniform distribution, default: 0..<1
    public mutating func fillUniform(_ buffer: UnsafeMutableBufferPointer<Float>, with range: Range<Float> = 0..<1) {
        buffer.baseAddress.map {
            fillUniform(start: $0, count: buffer.count, with: range)
        }
    }
    
    /// Sample random numbers from uniform distribution.
    /// - Parameters:
    ///   - start: Pointer to start location
    ///   - count: Number of elements to fill
    ///   - range: Range of uniform distribution, default: 0..<1
    /// - Precondition:
    ///   - `count` >= 0
    public mutating func fillUniform(start: UnsafeMutablePointer<Float>,
                                     count: Int,
                                     with range: Range<Float> = 0..<1) {
        fillUniform_generic(start: start, count: count, with: range)
    }
    
    
    // MARK: Double
    
    /// Sample random numbers from uniform distribution.
    /// - Parameters:
    ///   - count: Number of elements to sample
    ///   - range: Range of uniform distribution, default: 0..<1
    /// - Precondition:
    ///   - `count` >= 0
    public mutating func generateUniform(count: Int, from range: Range<Double> = 0..<1) -> [Double] {
        var array = [Double](repeating: 0, count: count)
        fillUniform(&array, with: range)
        return array
    }
    
    /// Sample random numbers from uniform distribution.
    /// - Parameters:
    ///   - array: Array to fill
    ///   - range: Range of uniform distribution, default: 0..<1
    public mutating func fillUniform(_ array: inout [Double], with range: Range<Double> = 0..<1) {
        array.withUnsafeMutableBufferPointer {
            fillUniform($0, with: range)
        }
    }
    
    /// Sample random numbers from uniform distribution.
    /// - Parameters:
    ///   - buffer: BufferPointer to fill
    ///   - range: Range of uniform distribution, default: 0..<1
    public mutating func fillUniform(_ buffer: UnsafeMutableBufferPointer<Double>, with range: Range<Double> = 0..<1) {
        buffer.baseAddress.map {
            fillUniform(start: $0, count: buffer.count, with: range)
        }
    }
    
    /// Sample random numbers from uniform distribution.
    /// - Parameters:
    ///   - start: Pointer to start location
    ///   - count: Number of elements to fill
    ///   - range: Range of uniform distribution, default: 0..<1
    /// - Precondition:
    ///   - `count` >= 0
    public mutating func fillUniform(start: UnsafeMutablePointer<Double>,
                                    count: Int,
                                    with range: Range<Double> = 0..<1) {
        fillUniform_generic(start: start, count: count, with: range)
    }
}
