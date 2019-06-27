extension XorshiftGenerator {
    /// Sample random numbers.
    /// - Parameters:
    ///   - count: Number of elements to sample
    /// - Precondition:
    ///   - `count` >= 0
    @inlinable
    public mutating func generate(count: Int) -> [UInt32] {
        var array = [UInt32](repeating: 0, count: count)
        fill(&array)
        return array
    }
    
    /// Fill array with random UInt32 numbers.
    @inlinable
    public mutating func fill(_ array: inout Array<UInt32>) {
        array.withUnsafeMutableBufferPointer {
            fill($0)
        }
    }
    
    /// Generate random UInt32 numbers.
    @inlinable
    public mutating func fill(_ buffer: UnsafeMutableBufferPointer<UInt32>) {
        buffer.baseAddress.map { fill(start: $0, count: buffer.count) }
    }
    
    /// Generate random UInt32 numbers.
    /// - Precondition:
    ///   - `count` >= 0
    @inlinable
    public mutating func fill(start: UnsafeMutablePointer<UInt32>,
                              count: Int) {
        precondition(count >= 0, "Invalid argument: `count` must not be less than 0.")
        
        var p = start
        
        for _ in 0..<count%4 {
            p.pointee = x ^ (x << 11)
            x = y; y = z; z = w;
            w = (w ^ (w >> 19)) ^ (p.pointee ^ (p.pointee >> 8))
            p.pointee = w
            p += 1
        }
        
        for _ in 0..<count/4 {
            let t1 = x ^ (x << 11)
            let t2 = y ^ (y << 11)
            let t3 = z ^ (z << 11)
            let t4 = w ^ (w << 11)
            
            x = w ^ (w >> 19) ^ (t1 ^ (t1 >> 8))
            y = x ^ (x >> 19) ^ (t2 ^ (t2 >> 8))
            z = y ^ (y >> 19) ^ (t3 ^ (t3 >> 8))
            w = z ^ (z >> 19) ^ (t4 ^ (t4 >> 8))
            
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
}
