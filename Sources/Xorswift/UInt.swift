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
        
        for _ in 0..<min(4, count) {
            p.pointee = x ^ (x << 11)
            x = y; y = z; z = w;
            w = (w ^ (w >> 19)) ^ (p.pointee ^ (p.pointee >> 8))
            p.pointee = w
            p += 1
        }
        
        guard count > 4 else {
            return
        }
        
        var xp = p - 4
        var wp = p - 1
        for _ in 0..<count-4 {
            p.pointee = xp.pointee ^ (xp.pointee << 11)
            p.pointee = (wp.pointee ^ (wp.pointee >> 19)) ^ (p.pointee ^ (p.pointee >> 8))
            
            p += 1
            wp += 1
            xp += 1
        }
        
        // write back
        x = xp.pointee
        xp += 1
        y = xp.pointee
        xp += 1
        z = xp.pointee
        xp += 1
        w = xp.pointee
    }
}
