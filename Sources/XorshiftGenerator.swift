public struct XorshiftGenerator: RandomNumberGenerator {
    public var x: UInt32
    public var y: UInt32
    public var z: UInt32
    public var w: UInt32
    
    public init(x: UInt32, y: UInt32, z: UInt32, w: UInt32) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
    
    public init<G: RandomNumberGenerator>(using generator: inout G) {
        self.init(x: generator.next(),
                  y: generator.next(),
                  z: generator.next(),
                  w: generator.next())
    }
    
    public init() {
        var g = SystemRandomNumberGenerator()
        self.init(using: &g)
    }
    
    /// Generate random UInt32 number.
    public mutating func next() -> UInt32 {
        let t = x ^ (x << 11)
        x = y; y = z; z = w;
        w = (w ^ (w >> 19)) ^ (t ^ (t >> 8))
        return w
    }
    
    /// Generate random UInt64 number.
    public mutating func next() -> UInt64 {
        let t1 = x ^ (x << 11)
        let t2 = y ^ (y << 11)
        x = z; y = w;
        z = (x ^ (x >> 19)) ^ (t1 ^ (t1 >> 8))
        w = (y ^ (y >> 19)) ^ (t2 ^ (t2 >> 8))
        return UInt64(z) << 32 | UInt64(w)
    }
    
    /// Fill array with random UInt32 numbers.
    public mutating func fill(_ array: inout Array<UInt32>) {
        array.withUnsafeMutableBufferPointer {
            fill($0)
        }
    }
    
    /// Generate random UInt32 numbers.
    public mutating func fill(_ buffer: UnsafeMutableBufferPointer<UInt32>) {
        buffer.baseAddress.map { fill(start: $0, count: buffer.count) }
    }
    
    /// Generate random UInt32 numbers.
    /// - Precondition:
    ///   - `count` >= 0
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
