import Foundation

extension Uniform where Base == XorshiftGenerator {
    // MARK: Generic
    
    mutating func fill_generic<T: FloatDouble>(start: UnsafeMutablePointer<T>, count: Int, with range: Range<T>) {
        precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
        T.fill12(start: start,
                 count: count,
                 multiplier: range.upperBound - range.lowerBound,
                 adder: 2*range.lowerBound - range.upperBound,
                 x: &base.x, y: &base.y, z: &base.z, w: &base.w)
    }
    
    // MARK: Float
    
    /// Sample random numbers from unifrom distribution.
    /// - Parameters:
    ///   - count: Number of elements to sample
    ///   - range: Range of uniform distribution, default: 0..<1
    /// - Precondition:
    ///   - `count` >= 0
    public mutating func generate(count: Int, from range: Range<Float> = 0..<1) -> [Float] {
        var array = [Float](repeating: 0, count: count)
        fill(&array, with: range)
        return array
    }
    
    /// Sample random numbers from unifrom distribution.
    /// - Parameters:
    ///   - array: Array to fill
    ///   - range: Range of uniform distribution, default: 0..<1
    public mutating func fill(_ array: inout [Float], with range: Range<Float> = 0..<1) {
        array.withUnsafeMutableBufferPointer {
            fill($0, with: range)
        }
    }
    
    /// Sample random numbers from unifrom distribution.
    /// - Parameters:
    ///   - buffer: BufferPointer to fill
    ///   - range: Range of uniform distribution, default: 0..<1
    public mutating func fill(_ buffer: UnsafeMutableBufferPointer<Float>, with range: Range<Float> = 0..<1) {
        buffer.baseAddress.map {
            fill(start: $0, count: buffer.count, with: range)
        }
    }
    
    /// Sample random numbers from unifrom distribution.
    /// - Parameters:
    ///   - start: Pointer to start location
    ///   - count: Number of elements to fill
    ///   - range: Range of uniform distribution, default: 0..<1
    /// - Precondition:
    ///   - `count` >= 0
    public mutating func fill(start: UnsafeMutablePointer<Float>,
                              count: Int,
                              with range: Range<Float> = 0..<1) {
        fill_generic(start: start, count: count, with: range)
    }
    
    
    // MARK: Double
    
    /// Sample random numbers from unifrom distribution.
    /// - Parameters:
    ///   - count: Number of elements to sample
    ///   - range: Range of uniform distribution, default: 0..<1
    /// - Precondition:
    ///   - `count` >= 0
    public mutating func generate(count: Int, from range: Range<Double> = 0..<1) -> [Double] {
        var array = [Double](repeating: 0, count: count)
        fill(&array, with: range)
        return array
    }
    
    /// Sample random numbers from unifrom distribution.
    /// - Parameters:
    ///   - array: Array to fill
    ///   - range: Range of uniform distribution, default: 0..<1
    public mutating func fill(_ array: inout [Double], with range: Range<Double> = 0..<1) {
        array.withUnsafeMutableBufferPointer {
            fill($0, with: range)
        }
    }
    
    /// Sample random numbers from unifrom distribution.
    /// - Parameters:
    ///   - buffer: BufferPointer to fill
    ///   - range: Range of uniform distribution, default: 0..<1
    public mutating func fill(_ buffer: UnsafeMutableBufferPointer<Double>, with range: Range<Double> = 0..<1) {
        buffer.baseAddress.map {
            fill(start: $0, count: buffer.count, with: range)
        }
    }
    
    /// Sample random numbers from unifrom distribution.
    /// - Parameters:
    ///   - start: Pointer to start location
    ///   - count: Number of elements to fill
    ///   - range: Range of uniform distribution, default: 0..<1
    /// - Precondition:
    ///   - `count` >= 0
    public mutating func fill(start: UnsafeMutablePointer<Double>,
                              count: Int,
                              with range: Range<Double> = 0..<1) {
        fill_generic(start: start, count: count, with: range)
    }
}
